#!/usr/bin/env node

const sql = require('mssql');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

require('dotenv').config({ path: path.resolve(__dirname, '..', '.env') });

// ---------------------------------------------------------------------------
// Parse CLI args
// ---------------------------------------------------------------------------
const args = process.argv.slice(2);
function getArg(name) {
  const idx = args.indexOf(`--${name}`);
  if (idx === -1 || idx + 1 >= args.length) return null;
  return args[idx + 1];
}

const workflow   = getArg('workflow');
const agent      = getArg('agent');
const promptType = getArg('type');
const filePath   = getArg('file');

if (!workflow || !agent || !promptType || !filePath) {
  console.error('Usage: node deploy-prompt.js --workflow <wf> --agent <agent> --type <system|user> --file <path>');
  process.exit(1);
}

// ---------------------------------------------------------------------------
// DB config from .env
// ---------------------------------------------------------------------------
const dbConfig = {
  server:   process.env.DB_HOST,
  port:     parseInt(process.env.DB_PORT || '1433', 10),
  user:     process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
  requestTimeout: 30000,
  connectionTimeout: 15000,
};

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------
async function main() {
  const resolvedPath = path.resolve(filePath);

  if (!fs.existsSync(resolvedPath)) {
    console.error(`File not found: ${resolvedPath}`);
    process.exit(1);
  }

  const content = fs.readFileSync(resolvedPath, 'utf-8');
  const contentHash = crypto.createHash('sha256').update(content, 'utf-8').digest('hex');

  let pool;
  try {
    pool = await sql.connect(dbConfig);

    const result = await pool.request()
      .input('workflow',     sql.NVarChar(50),  workflow)
      .input('agent',        sql.NVarChar(100), agent)
      .input('prompt_type',  sql.NVarChar(10),  promptType)
      .input('content',      sql.NVarChar(sql.MAX), content)
      .input('content_hash', sql.VarChar(64),   contentHash)
      .execute('dbo.a_magUpsertPrompt');

    const action = result.recordset?.[0]?.result || 'unknown';
    console.log(JSON.stringify({ workflow, agent, prompt_type: promptType, action, content_hash: contentHash }));
  } catch (err) {
    console.error(JSON.stringify({ error: err.message, workflow, agent, prompt_type: promptType }));
    process.exit(1);
  } finally {
    if (pool) await pool.close();
  }
}

main();
