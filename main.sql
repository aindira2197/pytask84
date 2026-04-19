CREATE TABLE sync_data (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255),
  phone VARCHAR(20),
  address VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE sync_log (
  id INT PRIMARY KEY,
  sync_data_id INT,
  sync_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(50),
  error_message VARCHAR(255),
  FOREIGN KEY (sync_data_id) REFERENCES sync_data(id)
);

INSERT INTO sync_data (name, email, phone, address)
VALUES ('John Doe', 'john@example.com', '1234567890', 'New York'),
       ('Jane Doe', 'jane@example.com', '0987654321', 'Los Angeles');

CREATE PROCEDURE sync_data_proc()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE sync_data_id INT;
  DECLARE cur1 CURSOR FOR SELECT id FROM sync_data;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;

  read_loop: LOOP
    FETCH cur1 INTO sync_data_id;
    IF done THEN
      LEAVE read_loop;
    END IF;

    INSERT INTO sync_log (sync_data_id, status)
    VALUES (sync_data_id, ' SYNCED ');

    UPDATE sync_data
    SET updated_at = NOW()
    WHERE id = sync_data_id;
  END LOOP;

  CLOSE cur1;
END;

CALL sync_data_proc();

SELECT * FROM sync_data;
SELECT * FROM sync_log;

CREATE TRIGGER sync_data_trigger
AFTER UPDATE ON sync_data
FOR EACH ROW
BEGIN
  INSERT INTO sync_log (sync_data_id, status)
  VALUES (NEW.id, ' SYNCED ');
END;

CREATE TRIGGER sync_data_delete_trigger
BEFORE DELETE ON sync_data
FOR EACH ROW
BEGIN
  INSERT INTO sync_log (sync_data_id, status)
  VALUES (OLD.id, ' DELETED ');
END;

CREATE VIEW sync_data_view AS
SELECT sd.id, sd.name, sd.email, sd.phone, sd.address, sl.status
FROM sync_data sd
LEFT JOIN sync_log sl ON sd.id = sl.sync_data_id;

SELECT * FROM sync_data_view;

CREATE INDEX idx_sync_data_id ON sync_log (sync_data_id);
CREATE INDEX idx_sync_data_name ON sync_data (name);
CREATE INDEX idx_sync_data_email ON sync_data (email);

EXPLAIN SELECT * FROM sync_data;
EXPLAIN SELECT * FROM sync_log;

ANALYZE TABLE sync_data;
ANALYZE TABLE sync_log;

CHECK TABLE sync_data;
CHECK TABLE sync_log;

OPTIMIZE TABLE sync_data;
OPTIMIZE TABLE sync_log;