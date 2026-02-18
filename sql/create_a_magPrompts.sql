-- ============================================================
-- Table: dbo.a_magPrompts
-- Stores all AI agent prompts used by N8N blog gen workflows.
-- ============================================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'a_magPrompts' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.a_magPrompts (
        id            INT IDENTITY(1,1) PRIMARY KEY,
        workflow      NVARCHAR(50)   NOT NULL,
        agent         NVARCHAR(100)  NOT NULL,
        prompt_type   NVARCHAR(10)   NOT NULL,
        content       NVARCHAR(MAX)  NOT NULL,
        content_hash  VARCHAR(64)    NOT NULL,
        updated_at    DATETIME       NOT NULL DEFAULT GETDATE(),
        created_at    DATETIME       NOT NULL DEFAULT GETDATE(),
        CONSTRAINT UQ_a_magPrompts UNIQUE (workflow, agent, prompt_type),
        CONSTRAINT CK_a_magPrompts_prompt_type CHECK (prompt_type IN ('system', 'user'))
    );
END;
GO

-- ============================================================
-- Stored Procedure: dbo.a_magUpsertPrompt
-- Upserts a single prompt row. Skips if content_hash matches.
-- Returns: 'inserted', 'updated', or 'skipped'.
-- ============================================================

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'a_magUpsertPrompt' AND schema_id = SCHEMA_ID('dbo'))
    DROP PROCEDURE dbo.a_magUpsertPrompt;
GO

CREATE PROCEDURE dbo.a_magUpsertPrompt
    @workflow     NVARCHAR(50),
    @agent        NVARCHAR(100),
    @prompt_type  NVARCHAR(10),
    @content      NVARCHAR(MAX),
    @content_hash VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @action NVARCHAR(10);

    MERGE dbo.a_magPrompts AS target
    USING (SELECT @workflow AS workflow, @agent AS agent, @prompt_type AS prompt_type) AS source
    ON target.workflow = source.workflow
       AND target.agent = source.agent
       AND target.prompt_type = source.prompt_type
    WHEN MATCHED AND target.content_hash <> @content_hash THEN
        UPDATE SET
            content      = @content,
            content_hash = @content_hash,
            updated_at   = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (workflow, agent, prompt_type, content, content_hash)
        VALUES (@workflow, @agent, @prompt_type, @content, @content_hash)
    ;

    -- Determine what happened
    IF @@ROWCOUNT = 0
        SET @action = 'skipped';
    ELSE IF EXISTS (
        SELECT 1 FROM dbo.a_magPrompts
        WHERE workflow = @workflow AND agent = @agent AND prompt_type = @prompt_type
              AND created_at = updated_at AND content_hash = @content_hash
    )
        SET @action = 'inserted';
    ELSE
        SET @action = 'updated';

    SELECT @action AS result;
END;
GO
