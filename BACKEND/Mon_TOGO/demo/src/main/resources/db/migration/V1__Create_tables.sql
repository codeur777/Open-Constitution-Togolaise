CREATE TABLE conversations (
    id VARCHAR(255) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    last_message TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE messages (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    is_user BOOLEAN NOT NULL,
    conversation_id VARCHAR(255) NOT NULL,
    created_at TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id)
);