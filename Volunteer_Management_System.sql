DROP TABLE volunteer_application CASCADE CONSTRAINTS;
DROP TABLE request_location CASCADE CONSTRAINTS;
DROP TABLE request_skill CASCADE CONSTRAINTS;
DROP TABLE request CASCADE CONSTRAINTS;
DROP TABLE beneficiary CASCADE CONSTRAINTS;
DROP TABLE interest_assignment CASCADE CONSTRAINTS;
DROP TABLE interest CASCADE CONSTRAINTS;
DROP TABLE skill_assignment CASCADE CONSTRAINTS;
DROP TABLE skill CASCADE CONSTRAINTS;
DROP TABLE volunteer_range CASCADE CONSTRAINTS;
DROP TABLE volunteer CASCADE CONSTRAINTS;
DROP TABLE city CASCADE CONSTRAINTS;

CREATE TABLE city (
    id NUMBER PRIMARY KEY CHECK (id > 0),
    name VARCHAR2(100) NOT NULL,
    latitude NUMBER,
    longitude NUMBER
);

CREATE TABLE volunteer (
    id VARCHAR2(11) PRIMARY KEY,
    birthdate DATE NOT NULL,
    city_id NUMBER,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    address VARCHAR2(200) NOT NULL,
    travel_readiness NUMBER NOT NULL,
    FOREIGN KEY (city_id) REFERENCES city(id)
);

CREATE TABLE volunteer_range (
    volunteer_id VARCHAR2(11),
    city_id NUMBER,
    PRIMARY KEY (volunteer_id, city_id),
    FOREIGN KEY (volunteer_id) REFERENCES volunteer(id) ON DELETE CASCADE,
    FOREIGN KEY (city_id) REFERENCES city(id)
);

CREATE TABLE skill (
    name VARCHAR2(100) PRIMARY KEY,
    description VARCHAR2(4000) NOT NULL
);

CREATE TABLE skill_assignment (
    volunteer_id VARCHAR2(11),
    skill_name VARCHAR2(100),
    PRIMARY KEY (volunteer_id, skill_name),
    FOREIGN KEY (volunteer_id) REFERENCES volunteer(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_name) REFERENCES skill(name)
);

CREATE TABLE interest (
    name VARCHAR2(100) PRIMARY KEY
);

CREATE TABLE interest_assignment (
    volunteer_id VARCHAR2(11),
    interest_name VARCHAR2(100),
    PRIMARY KEY (volunteer_id, interest_name),
    FOREIGN KEY (volunteer_id) REFERENCES volunteer(id) ON DELETE CASCADE,
    FOREIGN KEY (interest_name) REFERENCES interest(name)
);

CREATE TABLE beneficiary (
    id NUMBER PRIMARY KEY CHECK (id > 0),
    name VARCHAR2(100) NOT NULL,
    address VARCHAR2(200) NOT NULL,
    city_id NUMBER,
    FOREIGN KEY (city_id) REFERENCES city(id)
);

CREATE TABLE request (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    beneficiary_id NUMBER,
    title VARCHAR2(200),
    number_of_volunteers NUMBER CHECK (number_of_volunteers >= 1),
    priority_value NUMBER CHECK (priority_value >= 0 AND priority_value <= 5) NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    register_by_date TIMESTAMP NOT NULL,
    FOREIGN KEY (beneficiary_id) REFERENCES beneficiary(id)
);

CREATE TABLE request_skill (
    request_id NUMBER,
    skill_name VARCHAR2(100),
    min_need NUMBER CHECK (min_need >= 1) NOT NULL,
    value NUMBER CHECK (value >= 0 AND value <= 5) NOT NULL,
    PRIMARY KEY (request_id, skill_name),
    FOREIGN KEY (request_id) REFERENCES request(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_name) REFERENCES skill(name)
);

CREATE TABLE request_location (
    request_id NUMBER,
    city_id NUMBER,
    PRIMARY KEY (request_id, city_id),
    FOREIGN KEY (request_id) REFERENCES request(id) ON DELETE CASCADE,
    FOREIGN KEY (city_id) REFERENCES city(id)
);

CREATE TABLE volunteer_application (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    request_id NUMBER,
    volunteer_id VARCHAR2(11),
    modified TIMESTAMP,
    is_valid NUMBER(1) NOT NULL CHECK (is_valid IN (0, 1)),
    FOREIGN KEY (request_id) REFERENCES request(id) ON DELETE CASCADE,
    FOREIGN KEY (volunteer_id) REFERENCES volunteer(id)
);

-- Insert cities
INSERT INTO city (id, name, latitude, longitude) VALUES 
(1, 'New York', 40.7128, -74.0060);
INSERT INTO city (id, name, latitude, longitude) VALUES 
(2, 'Los Angeles', 34.0522, -118.2437);
INSERT INTO city (id, name, latitude, longitude) VALUES 
(3, 'Chicago', 41.8781, -87.6298);
INSERT INTO city (id, name, latitude, longitude) VALUES 
(4, 'Houston', 29.7604, -95.3698);
INSERT INTO city (id, name, latitude, longitude) VALUES 
(5, 'Phoenix', 33.4484, -112.0740);

-- Insert volunteers
INSERT INTO volunteer (id, birthdate, city_id, name, email, address, travel_readiness) VALUES 
('V1001', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 1, 'John Smith', 'john.smith@email.com', '123 Main St', 3);
INSERT INTO volunteer (id, birthdate, city_id, name, email, address, travel_readiness) VALUES 
('V1002', TO_DATE('1985-08-22', 'YYYY-MM-DD'), 2, 'Sarah Johnson', 'sarah.j@email.com', '456 Oak Ave', 2);
INSERT INTO volunteer (id, birthdate, city_id, name, email, address, travel_readiness) VALUES 
('V1003', TO_DATE('1995-02-10', 'YYYY-MM-DD'), 3, 'Michael Brown', 'michael.b@email.com', '789 Pine Rd', 4);
INSERT INTO volunteer (id, birthdate, city_id, name, email, address, travel_readiness) VALUES 
('V1004', TO_DATE('1988-11-30', 'YYYY-MM-DD'), 4, 'Emily Davis', 'emily.d@email.com', '321 Elm St', 1);
INSERT INTO volunteer (id, birthdate, city_id, name, email, address, travel_readiness) VALUES 
('V1005', TO_DATE('1992-07-18', 'YYYY-MM-DD'), 5, 'David Wilson', 'david.w@email.com', '654 Maple Dr', 5);

-- Insert volunteer ranges
INSERT INTO volunteer_range (volunteer_id, city_id) VALUES ('V1001', 1);
INSERT INTO volunteer_range (volunteer_id, city_id) VALUES ('V1001', 2);
INSERT INTO volunteer_range (volunteer_id, city_id) VALUES ('V1002', 2);
INSERT INTO volunteer_range (volunteer_id, city_id) VALUES ('V1003', 3);
INSERT INTO volunteer_range (volunteer_id, city_id) VALUES ('V1004', 4);

-- Insert skills
INSERT INTO skill (name, description) VALUES 
('First Aid', 'Basic medical assistance and CPR');
INSERT INTO skill (name, description) VALUES 
('Carpentry', 'Woodworking and construction skills');
INSERT INTO skill (name, description) VALUES 
('Teaching', 'Educational instruction abilities');
INSERT INTO skill (name, description) VALUES 
('Cooking', 'Food preparation for large groups');
INSERT INTO skill (name, description) VALUES 
('IT Support', 'Computer troubleshooting and maintenance');

-- Insert skill assignments
INSERT INTO skill_assignment (volunteer_id, skill_name) VALUES ('V1001', 'First Aid');
INSERT INTO skill_assignment (volunteer_id, skill_name) VALUES ('V1001', 'Carpentry');
INSERT INTO skill_assignment (volunteer_id, skill_name) VALUES ('V1002', 'Teaching');
INSERT INTO skill_assignment (volunteer_id, skill_name) VALUES ('V1003', 'IT Support');
INSERT INTO skill_assignment (volunteer_id, skill_name) VALUES ('V1004', 'Cooking');

-- Insert interests
INSERT INTO interest (name) VALUES ('Disaster Relief');
INSERT INTO interest (name) VALUES ('Education');
INSERT INTO interest (name) VALUES ('Elderly Care');
INSERT INTO interest (name) VALUES ('Environmental');
INSERT INTO interest (name) VALUES ('Animal Welfare');

-- Insert interest assignments
INSERT INTO interest_assignment (volunteer_id, interest_name) VALUES ('V1001', 'Disaster Relief');
INSERT INTO interest_assignment (volunteer_id, interest_name) VALUES ('V1002', 'Education');
INSERT INTO interest_assignment (volunteer_id, interest_name) VALUES ('V1003', 'Environmental');
INSERT INTO interest_assignment (volunteer_id, interest_name) VALUES ('V1004', 'Elderly Care');
INSERT INTO interest_assignment (volunteer_id, interest_name) VALUES ('V1005', 'Animal Welfare');

-- Insert beneficiaries
INSERT INTO beneficiary (id, name, address, city_id) VALUES 
(1, 'Red Cross', '123 Humanitarian Way', 1);
INSERT INTO beneficiary (id, name, address, city_id) VALUES 
(2, 'Local School District', '456 Education Blvd', 2);
INSERT INTO beneficiary (id, name, address, city_id) VALUES 
(3, 'Senior Care Center', '789 Golden Years Ln', 3);
INSERT INTO beneficiary (id, name, address, city_id) VALUES 
(4, 'Community Kitchen', '321 Nourishment St', 4);
INSERT INTO beneficiary (id, name, address, city_id) VALUES 
(5, 'Animal Shelter', '654 Furry Friends Rd', 5);

-- Insert requests
INSERT INTO request (beneficiary_id, title, number_of_volunteers, priority_value, start_date, end_date, register_by_date) VALUES 
(1, 'Disaster Response Team', 10, 5, TO_TIMESTAMP('2023-11-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-11-10 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-25 23:59:59', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO request (beneficiary_id, title, number_of_volunteers, priority_value, start_date, end_date, register_by_date) VALUES 
(2, 'After School Tutoring', 5, 3, TO_TIMESTAMP('2023-11-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-12-15 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-11-10 23:59:59', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO request (beneficiary_id, title, number_of_volunteers, priority_value, start_date, end_date, register_by_date) VALUES 
(3, 'Senior Companion Program', 8, 4, TO_TIMESTAMP('2023-11-05 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-11-30 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO request (beneficiary_id, title, number_of_volunteers, priority_value, start_date, end_date, register_by_date) VALUES 
(4, 'Community Meal Prep', 6, 2, TO_TIMESTAMP('2023-11-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-11-20 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-11-15 23:59:59', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO request (beneficiary_id, title, number_of_volunteers, priority_value, start_date, end_date, register_by_date) VALUES 
(5, 'Animal Shelter Support', 4, 3, TO_TIMESTAMP('2023-12-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-12-31 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-11-25 23:59:59', 'YYYY-MM-DD HH24:MI:SS'));

-- Insert request skills
INSERT INTO request_skill (request_id, skill_name, min_need, value) VALUES (1, 'First Aid', 3, 5);
INSERT INTO request_skill (request_id, skill_name, min_need, value) VALUES (1, 'Carpentry', 2, 4);
INSERT INTO request_skill (request_id, skill_name, min_need, value) VALUES (2, 'Teaching', 5, 5);
INSERT INTO request_skill (request_id, skill_name, min_need, value) VALUES (3, 'Cooking', 2, 3);
INSERT INTO request_skill (request_id, skill_name, min_need, value) VALUES (4, 'Cooking', 4, 4);

-- Insert request locations
INSERT INTO request_location (request_id, city_id) VALUES (1, 1);
INSERT INTO request_location (request_id, city_id) VALUES (1, 2);
INSERT INTO request_location (request_id, city_id) VALUES (2, 2);
INSERT INTO request_location (request_id, city_id) VALUES (3, 3);
INSERT INTO request_location (request_id, city_id) VALUES (4, 4);

-- Insert volunteer applications
INSERT INTO volunteer_application (request_id, volunteer_id, modified, is_valid) VALUES 
(1, 'V1001', SYSTIMESTAMP, 1);
INSERT INTO volunteer_application (request_id, volunteer_id, modified, is_valid) VALUES 
(1, 'V1002', SYSTIMESTAMP, 1);
INSERT INTO volunteer_application (request_id, volunteer_id, modified, is_valid) VALUES 
(2, 'V1002', SYSTIMESTAMP, 1);
INSERT INTO volunteer_application (request_id, volunteer_id, modified, is_valid) VALUES 
(3, 'V1004', SYSTIMESTAMP, 1);
INSERT INTO volunteer_application (request_id, volunteer_id, modified, is_valid) VALUES 
(5, 'V1005', SYSTIMESTAMP, 1);

-- 1. Find all volunteers with First Aid skill
SELECT v.name, v.email 
FROM volunteer v
JOIN skill_assignment sa ON v.id = sa.volunteer_id
WHERE sa.skill_name = 'First Aid';

-- 2. Count volunteers by city
SELECT c.name AS city, COUNT(v.id) AS volunteer_count
FROM city c
LEFT JOIN volunteer v ON c.id = v.city_id
GROUP BY c.name
ORDER BY volunteer_count DESC;

-- 3. Find high-priority requests needing specific skills
SELECT r.title, r.priority_value, rs.skill_name, rs.min_need
FROM request r
JOIN request_skill rs ON r.id = rs.request_id
WHERE r.priority_value >= 4
ORDER BY r.priority_value DESC;

-- 4. List volunteers who applied to multiple requests
SELECT v.name, COUNT(va.request_id) AS applications
FROM volunteer v
JOIN volunteer_application va ON v.id = va.volunteer_id
GROUP BY v.name
HAVING COUNT(va.request_id) > 1
ORDER BY applications DESC;

-- 5. Find matching volunteers for a specific request (request_id = 1)
SELECT v.id, v.name, v.email, 
       COUNT(sa.skill_name) AS matching_skills,
       SUM(rs.value) AS skill_match_score
FROM volunteer v
JOIN skill_assignment sa ON v.id = sa.volunteer_id
JOIN request_skill rs ON sa.skill_name = rs.skill_name
JOIN request_location rl ON rs.request_id = rl.request_id
WHERE rs.request_id = 1
AND (v.city_id = rl.city_id OR EXISTS (
    SELECT 1 FROM volunteer_range vr 
    WHERE vr.volunteer_id = v.id AND vr.city_id = rl.city_id
))
GROUP BY v.id, v.name, v.email
ORDER BY skill_match_score DESC;

-- 1. Volunteer details view
CREATE OR REPLACE VIEW volunteer_details AS
SELECT v.id, v.name, v.email, v.birthdate, c.name AS city, 
       v.travel_readiness, v.address
FROM volunteer v
JOIN city c ON v.city_id = c.id;

-- 2. Volunteers with multiple skills
CREATE OR REPLACE VIEW volunteers_with_multiple_skills AS
SELECT 
    v.id AS volunteer_id,
    v.name AS volunteer_name,
    COUNT(sa.skill_name) AS skill_count,
    LISTAGG(s.name, ', ') WITHIN GROUP (ORDER BY s.name) AS skills
FROM 
    volunteer v
JOIN 
    skill_assignment sa ON v.id = sa.volunteer_id
JOIN 
    skill s ON sa.skill_name = s.name
GROUP BY 
    v.id, v.name
HAVING 
    COUNT(sa.skill_name) > 1
ORDER BY 
    skill_count DESC;

-- 3. Volunteer interests view
CREATE OR REPLACE VIEW volunteer_interests AS
SELECT v.id AS volunteer_id, v.name AS volunteer_name, i.name AS interest
FROM volunteer v
JOIN interest_assignment ia ON v.id = ia.volunteer_id
JOIN interest i ON ia.interest_name = i.name;

-- 4. Request summary view
CREATE OR REPLACE VIEW request_summary AS
SELECT r.id, r.title, b.name AS beneficiary, 
       r.number_of_volunteers, r.priority_value,
       r.start_date, r.end_date
FROM request r
JOIN beneficiary b ON r.beneficiary_id = b.id;

-- 5. Request skills view
CREATE OR REPLACE VIEW request_skills_detail AS
SELECT r.id AS request_id, r.title, rs.skill_name, 
       rs.min_need, rs.value AS priority
FROM request r
JOIN request_skill rs ON r.id = rs.request_id;

-- 6. Request locations view
CREATE OR REPLACE VIEW request_locations AS
SELECT r.id AS request_id, r.title, c.name AS city
FROM request r
JOIN request_location rl ON r.id = rl.request_id
JOIN city c ON rl.city_id = c.id;

-- 7. Volunteer applications view
CREATE OR REPLACE VIEW volunteer_applications AS
SELECT va.id AS application_id, r.title AS request_title,
       v.name AS volunteer_name, v.email AS volunteer_email,
       b.name AS beneficiary, va.modified, 
       CASE va.is_valid WHEN 1 THEN 'Valid' ELSE 'Invalid' END AS status
FROM volunteer_application va
JOIN request r ON va.request_id = r.id
JOIN volunteer v ON va.volunteer_id = v.id
JOIN beneficiary b ON r.beneficiary_id = b.id;

-- 8. Volunteer availability view
CREATE OR REPLACE VIEW volunteer_availability AS
SELECT v.id, v.name, c.name AS home_city,
       LISTAGG(c2.name, ', ') WITHIN GROUP (ORDER BY c2.name) AS available_cities
FROM volunteer v
JOIN city c ON v.city_id = c.id
LEFT JOIN volunteer_range vr ON v.id = vr.volunteer_id
LEFT JOIN city c2 ON vr.city_id = c2.id
GROUP BY v.id, v.name, c.name;

-- 9. Skill demand view
CREATE OR REPLACE VIEW skill_demand AS
SELECT s.name AS skill, COUNT(rs.request_id) AS request_count,
       SUM(rs.min_need) AS total_volunteers_needed
FROM skill s
LEFT JOIN request_skill rs ON s.name = rs.skill_name
GROUP BY s.name
ORDER BY request_count DESC;

-- 10. Volunteer matching score view
CREATE OR REPLACE VIEW volunteer_match_scores AS
SELECT v.id AS volunteer_id, v.name AS volunteer_name,
       r.id AS request_id, r.title AS request_title,
       COUNT(sa.skill_name) AS matching_skills,
       SUM(rs.value) AS skill_match_score
FROM volunteer v
CROSS JOIN request r
JOIN request_skill rs ON r.id = rs.request_id
JOIN skill_assignment sa ON v.id = sa.volunteer_id AND sa.skill_name = rs.skill_name
JOIN request_location rl ON r.id = rl.request_id
WHERE (v.city_id = rl.city_id OR EXISTS (
    SELECT 1 FROM volunteer_range vr 
    WHERE vr.volunteer_id = v.id AND vr.city_id = rl.city_id
))
GROUP BY v.id, v.name, r.id, r.title
ORDER BY skill_match_score DESC;

-- 11. Upcoming requests view
CREATE OR REPLACE VIEW upcoming_requests AS
SELECT r.id, r.title, b.name AS beneficiary,
       r.start_date, r.register_by_date,
       r.number_of_volunteers - NVL(a.application_count, 0) AS volunteers_needed
FROM request r
JOIN beneficiary b ON r.beneficiary_id = b.id
LEFT JOIN (
    SELECT request_id, COUNT(*) AS application_count
    FROM volunteer_application
    GROUP BY request_id
) a ON r.id = a.request_id
WHERE r.register_by_date > SYSDATE
ORDER BY r.start_date;

-- 12. Volunteer participation view
CREATE OR REPLACE VIEW volunteer_participation AS
SELECT v.id, v.name, COUNT(va.id) AS total_applications,
       COUNT(DISTINCT r.beneficiary_id) AS unique_beneficiaries
FROM volunteer v
LEFT JOIN volunteer_application va ON v.id = va.volunteer_id
LEFT JOIN request r ON va.request_id = r.id
GROUP BY v.id, v.name
ORDER BY total_applications DESC;

-- 13. Beneficiary activity view
CREATE OR REPLACE VIEW beneficiary_activity AS
SELECT b.id, b.name, COUNT(r.id) AS total_requests,
       SUM(r.number_of_volunteers) AS total_volunteers_requested
FROM beneficiary b
LEFT JOIN request r ON b.id = r.beneficiary_id
GROUP BY b.id, b.name
ORDER BY total_requests DESC;

-- 14. Volunteer age groups view
CREATE OR REPLACE VIEW volunteer_age_groups AS
SELECT 
    CASE 
        WHEN MONTHS_BETWEEN(SYSDATE, birthdate)/12 < 18 THEN 'Under 18'
        WHEN MONTHS_BETWEEN(SYSDATE, birthdate)/12 BETWEEN 18 AND 25 THEN '18-25'
        WHEN MONTHS_BETWEEN(SYSDATE, birthdate)/12 BETWEEN 26 AND 35 THEN '26-35'
        WHEN MONTHS_BETWEEN(SYSDATE, birthdate)/12 BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(*) AS volunteer_count
FROM volunteer
GROUP BY 
    CASE 
        WHEN MONTHS_BETWEEN(SYSDATE, birthdate)/12 < 18 THEN 'Under 18'
        WHEN MONTHS_BETWEEN(SYSDATE, birthdate)/12 BETWEEN 18 AND 25 THEN '18-25'
        WHEN MONTHS_BETWEEN(SYSDATE, birthdate)/12 BETWEEN 26 AND 35 THEN '26-35'
        WHEN MONTHS_BETWEEN(SYSDATE, birthdate)/12 BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Over 50'
    END
ORDER BY MIN(MONTHS_BETWEEN(SYSDATE, birthdate)/12);

-- 15. Request fulfillment status view
CREATE OR REPLACE VIEW request_fulfillment AS
SELECT r.id, r.title, b.name AS beneficiary,
       r.number_of_volunteers AS needed,
       NVL(a.application_count, 0) AS applied,
       CASE 
           WHEN NVL(a.application_count, 0) >= r.number_of_volunteers THEN 'Fulfilled'
           WHEN NVL(a.application_count, 0) = 0 THEN 'No applications'
           ELSE 'Partially fulfilled'
       END AS status
FROM request r
JOIN beneficiary b ON r.beneficiary_id = b.id
LEFT JOIN (
    SELECT request_id, COUNT(*) AS application_count
    FROM volunteer_application
    WHERE is_valid = 1
    GROUP BY request_id
) a ON r.id = a.request_id;

-- 16. Volunteer travel readiness view
CREATE OR REPLACE VIEW volunteer_travel_readiness AS
SELECT 
    CASE travel_readiness
        WHEN 1 THEN 'Local only'
        WHEN 2 THEN 'Limited travel'
        WHEN 3 THEN 'Within region'
        WHEN 4 THEN 'Willing to travel'
        WHEN 5 THEN 'Anywhere'
        ELSE 'Unknown'
    END AS travel_level,
    COUNT(*) AS volunteer_count
FROM volunteer
GROUP BY travel_readiness
ORDER BY travel_readiness;