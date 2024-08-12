CREATE TABLE IF NOT EXISTS patients (
    id SERIAL PRIMARY KEY,
    cpf VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    birthdate DATE,
    address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS doctors (
    id SERIAL PRIMARY KEY,
    crm VARCHAR(10) NOT NULL,
    crm_state VARCHAR(2) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS exams (
    id SERIAL PRIMARY KEY,
    result_token VARCHAR(255) UNIQUE NOT NULL,
    result_date DATE,
    patient_id INTEGER REFERENCES patients(id),
    doctor_id INTEGER REFERENCES doctors(id)
);

CREATE TABLE IF NOT EXISTS tests (
    id SERIAL PRIMARY KEY,
    exam_id INTEGER REFERENCES exams(id),
    type VARCHAR(255),
    limits VARCHAR(255),
    results VARCHAR(255)
);

ALTER TABLE doctors
ADD CONSTRAINT unique_crm_state UNIQUE (crm, crm_state);


\q
