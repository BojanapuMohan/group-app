--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: availabilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE availabilities (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    employee_id integer,
    call_on_vacation boolean DEFAULT false
);


--
-- Name: availabilities_employees_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE availabilities_employees_roles (
    availability_id integer NOT NULL,
    employees_role_id integer NOT NULL
);


--
-- Name: availabilities_facilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE availabilities_facilities (
    id integer NOT NULL,
    availability_id integer,
    facility_id integer
);


--
-- Name: availabilities_facilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE availabilities_facilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: availabilities_facilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE availabilities_facilities_id_seq OWNED BY availabilities_facilities.id;


--
-- Name: availabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE availabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: availabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE availabilities_id_seq OWNED BY availabilities.id;


--
-- Name: availability_day_of_week_availability; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE availability_day_of_week_availability (
    availability_id integer NOT NULL,
    day_of_week_availability_id integer NOT NULL
);


--
-- Name: day_of_week_availabilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE day_of_week_availabilities (
    id integer NOT NULL,
    day_of_week integer,
    time_of_day character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: day_of_week_availabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE day_of_week_availabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: day_of_week_availabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE day_of_week_availabilities_id_seq OWNED BY day_of_week_availabilities.id;


--
-- Name: employee_call_out_lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee_call_out_lists (
    id integer NOT NULL,
    call_out_shift_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    filtered_at timestamp without time zone
);


--
-- Name: employee_call_out_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employee_call_out_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_call_out_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employee_call_out_lists_id_seq OWNED BY employee_call_out_lists.id;


--
-- Name: employee_call_out_results; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee_call_out_results (
    id integer NOT NULL,
    result character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: employee_call_out_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employee_call_out_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_call_out_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employee_call_out_results_id_seq OWNED BY employee_call_out_results.id;


--
-- Name: employee_call_outs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee_call_outs (
    id integer NOT NULL,
    employee_call_out_list_id integer,
    employee_id integer,
    overtime boolean DEFAULT false,
    rejected boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    employee_call_out_result_id integer,
    called_at timestamp without time zone,
    "position" integer,
    rule character varying(255)[] DEFAULT '{}'::character varying[]
);


--
-- Name: employees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employees (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    phone character varying(255),
    employee_class character varying(255),
    seniority character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    enabled boolean DEFAULT true,
    hire_date date,
    sin character varying(255),
    date_of_birth date,
    email character varying(255),
    address character varying(255),
    hourly_rate character varying(255),
    "group" character varying(255),
    registration_expiry date,
    first_aid_expiry date,
    whmis_expiry date,
    food_safe_expiry date,
    nvci_expiry date,
    crc_expiry date,
    evaluation_due date
);


--
-- Name: employee_call_out_results_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW employee_call_out_results_view AS
 SELECT employee_call_outs.id,
    employee_call_outs.employee_id,
    employees.first_name,
    employees.last_name,
    employee_call_outs.updated_at,
    employee_call_outs.called_at,
    (employee_call_outs.called_at)::date AS called_on,
    employee_call_out_results.result
   FROM ((employee_call_outs
     JOIN employees ON ((employees.id = employee_call_outs.employee_id)))
     JOIN employee_call_out_results ON ((employee_call_out_results.id = employee_call_outs.employee_call_out_result_id)))
  ORDER BY (employee_call_outs.called_at)::date, employees.last_name, employees.first_name;


--
-- Name: employee_call_outs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employee_call_outs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_call_outs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employee_call_outs_id_seq OWNED BY employee_call_outs.id;


--
-- Name: employee_shifts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee_shifts (
    id integer NOT NULL,
    start_date date,
    end_date date,
    shift_id integer,
    employee_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    replaced_shift_id integer,
    shift_replacement_reason_id integer,
    type character varying(255)
);


--
-- Name: employee_shift_replacements; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW employee_shift_replacements AS
 SELECT new_shift.created_at,
    new_shift.start_date,
    new_shift.end_date,
    initial_shift.employee_id,
    new_shift.shift_id,
    new_shift.shift_replacement_reason_id
   FROM employee_shifts initial_shift,
    employee_shifts new_shift
  WHERE (new_shift.replaced_shift_id = initial_shift.id);


--
-- Name: employee_shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employee_shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employee_shifts_id_seq OWNED BY employee_shifts.id;


--
-- Name: employees_employees_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employees_employees_roles (
    employee_id integer NOT NULL,
    employees_role_id integer NOT NULL
);


--
-- Name: employees_facilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employees_facilities (
    id integer NOT NULL,
    employee_id integer,
    facility_id integer
);


--
-- Name: employees_facilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employees_facilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employees_facilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employees_facilities_id_seq OWNED BY employees_facilities.id;


--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employees_id_seq OWNED BY employees.id;


--
-- Name: employees_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employees_roles (
    id integer NOT NULL,
    role_name character varying(255),
    role_abbreviation character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    enabled boolean DEFAULT true
);


--
-- Name: employees_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employees_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employees_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employees_roles_id_seq OWNED BY employees_roles.id;


--
-- Name: facilities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE facilities (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    enabled boolean DEFAULT true,
    has_shared_duty_shifts boolean DEFAULT false
);


--
-- Name: facilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE facilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE facilities_id_seq OWNED BY facilities.id;


--
-- Name: facilities_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE facilities_users (
    id integer NOT NULL,
    user_id integer,
    facility_id integer
);


--
-- Name: facilities_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE facilities_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facilities_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE facilities_users_id_seq OWNED BY facilities_users.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notes (
    id integer NOT NULL,
    user_id integer,
    note text,
    employee_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255),
    resource_id integer,
    resource_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: shift_replacement_reasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shift_replacement_reasons (
    id integer NOT NULL,
    reason character varying(255),
    abreviation character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: shift_replacement_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shift_replacement_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shift_replacement_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shift_replacement_reasons_id_seq OWNED BY shift_replacement_reasons.id;


--
-- Name: shift_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shift_types (
    id integer NOT NULL,
    name character varying(255),
    duration integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: shift_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shift_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shift_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shift_types_id_seq OWNED BY shift_types.id;


--
-- Name: shifts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shifts (
    id integer NOT NULL,
    start_date date,
    end_date date,
    facility_id integer,
    employees_role_id integer,
    schedule_store text,
    start_hour integer,
    start_minute integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    time_of_day character varying(255),
    shift_type_id integer
);


--
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shifts_id_seq OWNED BY shifts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    invitation_token character varying(255),
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_id integer,
    invited_by_type character varying(255),
    enabled boolean DEFAULT true
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_roles (
    user_id integer,
    role_id integer
);


--
-- Name: vacations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW vacations AS
 SELECT employee_shifts.start_date,
    employee_shifts.end_date,
    replaced_shifts.employee_id,
    employee_shifts.shift_id
   FROM employee_shifts employee_shifts,
    employee_shifts replaced_shifts
  WHERE ((employee_shifts.replaced_shift_id = replaced_shifts.id) AND (employee_shifts.shift_replacement_reason_id = ( SELECT shift_replacement_reasons.id
           FROM shift_replacement_reasons
          WHERE ((shift_replacement_reasons.reason)::text = 'Vacation'::text))));


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY availabilities ALTER COLUMN id SET DEFAULT nextval('availabilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY availabilities_facilities ALTER COLUMN id SET DEFAULT nextval('availabilities_facilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY day_of_week_availabilities ALTER COLUMN id SET DEFAULT nextval('day_of_week_availabilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_call_out_lists ALTER COLUMN id SET DEFAULT nextval('employee_call_out_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_call_out_results ALTER COLUMN id SET DEFAULT nextval('employee_call_out_results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_call_outs ALTER COLUMN id SET DEFAULT nextval('employee_call_outs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_shifts ALTER COLUMN id SET DEFAULT nextval('employee_shifts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees ALTER COLUMN id SET DEFAULT nextval('employees_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees_facilities ALTER COLUMN id SET DEFAULT nextval('employees_facilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees_roles ALTER COLUMN id SET DEFAULT nextval('employees_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY facilities ALTER COLUMN id SET DEFAULT nextval('facilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY facilities_users ALTER COLUMN id SET DEFAULT nextval('facilities_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shift_replacement_reasons ALTER COLUMN id SET DEFAULT nextval('shift_replacement_reasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shift_types ALTER COLUMN id SET DEFAULT nextval('shift_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shifts ALTER COLUMN id SET DEFAULT nextval('shifts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: availabilities_facilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY availabilities_facilities
    ADD CONSTRAINT availabilities_facilities_pkey PRIMARY KEY (id);


--
-- Name: availabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY availabilities
    ADD CONSTRAINT availabilities_pkey PRIMARY KEY (id);


--
-- Name: day_of_week_availabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY day_of_week_availabilities
    ADD CONSTRAINT day_of_week_availabilities_pkey PRIMARY KEY (id);


--
-- Name: employee_call_out_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_call_out_lists
    ADD CONSTRAINT employee_call_out_lists_pkey PRIMARY KEY (id);


--
-- Name: employee_call_out_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_call_out_results
    ADD CONSTRAINT employee_call_out_results_pkey PRIMARY KEY (id);


--
-- Name: employee_call_outs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_call_outs
    ADD CONSTRAINT employee_call_outs_pkey PRIMARY KEY (id);


--
-- Name: employee_shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_shifts
    ADD CONSTRAINT employee_shifts_pkey PRIMARY KEY (id);


--
-- Name: employees_facilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employees_facilities
    ADD CONSTRAINT employees_facilities_pkey PRIMARY KEY (id);


--
-- Name: employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: employees_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employees_roles
    ADD CONSTRAINT employees_roles_pkey PRIMARY KEY (id);


--
-- Name: facilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY facilities
    ADD CONSTRAINT facilities_pkey PRIMARY KEY (id);


--
-- Name: facilities_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY facilities_users
    ADD CONSTRAINT facilities_users_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: shift_replacement_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shift_replacement_reasons
    ADD CONSTRAINT shift_replacement_reasons_pkey PRIMARY KEY (id);


--
-- Name: shift_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shift_types
    ADD CONSTRAINT shift_types_pkey PRIMARY KEY (id);


--
-- Name: shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_availability_day_of_week_availability_on_availability_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_availability_day_of_week_availability_on_availability_id ON availability_day_of_week_availability USING btree (availability_id);


--
-- Name: index_availability_dow_availability_on_dow_availability_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_availability_dow_availability_on_dow_availability_id ON availability_day_of_week_availability USING btree (day_of_week_availability_id);


--
-- Name: index_employee_call_outs_on_employee_call_out_list_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_employee_call_outs_on_employee_call_out_list_id ON employee_call_outs USING btree (employee_call_out_list_id);


--
-- Name: index_employee_call_outs_on_employee_call_out_result_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_employee_call_outs_on_employee_call_out_result_id ON employee_call_outs USING btree (employee_call_out_result_id);


--
-- Name: index_employee_call_outs_on_employee_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_employee_call_outs_on_employee_id ON employee_call_outs USING btree (employee_id);


--
-- Name: index_employee_shifts_on_employee_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_employee_shifts_on_employee_id ON employee_shifts USING btree (employee_id);


--
-- Name: index_employee_shifts_on_replaced_shift_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_employee_shifts_on_replaced_shift_id ON employee_shifts USING btree (replaced_shift_id);


--
-- Name: index_employee_shifts_on_shift_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_employee_shifts_on_shift_id ON employee_shifts USING btree (shift_id);


--
-- Name: index_employee_shifts_on_shift_replacement_reason_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_employee_shifts_on_shift_replacement_reason_id ON employee_shifts USING btree (shift_replacement_reason_id);


--
-- Name: index_notes_on_employee_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notes_on_employee_id ON notes USING btree (employee_id);


--
-- Name: index_on_availability_id_and_employees_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_on_availability_id_and_employees_role_id ON availabilities_employees_roles USING btree (availability_id, employees_role_id);


--
-- Name: index_on_employee_id_and_employees_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_on_employee_id_and_employees_role_id ON employees_employees_roles USING btree (employee_id, employees_role_id);


--
-- Name: index_on_employees_role_id_and_availability_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_on_employees_role_id_and_availability_id ON availabilities_employees_roles USING btree (employees_role_id, availability_id);


--
-- Name: index_on_employees_role_id_and_employee_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_on_employees_role_id_and_employee_id ON employees_employees_roles USING btree (employees_role_id, employee_id);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roles_on_name ON roles USING btree (name);


--
-- Name: index_roles_on_name_and_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roles_on_name_and_resource_type_and_resource_id ON roles USING btree (name, resource_type, resource_id);


--
-- Name: index_shifts_on_employees_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shifts_on_employees_role_id ON shifts USING btree (employees_role_id);


--
-- Name: index_shifts_on_facility_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shifts_on_facility_id ON shifts USING btree (facility_id);


--
-- Name: index_shifts_on_shift_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shifts_on_shift_type_id ON shifts USING btree (shift_type_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON users USING btree (invitation_token);


--
-- Name: index_users_on_invited_by_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_invited_by_id ON users USING btree (invited_by_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_roles_on_user_id_and_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_roles_on_user_id_and_role_id ON users_roles USING btree (user_id, role_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20131224213003');

INSERT INTO schema_migrations (version) VALUES ('20131224213006');

INSERT INTO schema_migrations (version) VALUES ('20131224213008');

INSERT INTO schema_migrations (version) VALUES ('20131224213013');

INSERT INTO schema_migrations (version) VALUES ('20131224213033');

INSERT INTO schema_migrations (version) VALUES ('20140207100913');

INSERT INTO schema_migrations (version) VALUES ('20140207101019');

INSERT INTO schema_migrations (version) VALUES ('20140207123902');

INSERT INTO schema_migrations (version) VALUES ('20140207130634');

INSERT INTO schema_migrations (version) VALUES ('20140207135505');

INSERT INTO schema_migrations (version) VALUES ('20140207135808');

INSERT INTO schema_migrations (version) VALUES ('20140207141308');

INSERT INTO schema_migrations (version) VALUES ('20140210055445');

INSERT INTO schema_migrations (version) VALUES ('20140210215829');

INSERT INTO schema_migrations (version) VALUES ('20140210215849');

INSERT INTO schema_migrations (version) VALUES ('20140212051810');

INSERT INTO schema_migrations (version) VALUES ('20140212070804');

INSERT INTO schema_migrations (version) VALUES ('20140213043418');

INSERT INTO schema_migrations (version) VALUES ('20140213043827');

INSERT INTO schema_migrations (version) VALUES ('20140213070233');

INSERT INTO schema_migrations (version) VALUES ('20140213072125');

INSERT INTO schema_migrations (version) VALUES ('20140213081658');

INSERT INTO schema_migrations (version) VALUES ('20140214065931');

INSERT INTO schema_migrations (version) VALUES ('20140214125630');

INSERT INTO schema_migrations (version) VALUES ('20140215165258');

INSERT INTO schema_migrations (version) VALUES ('20140215170816');

INSERT INTO schema_migrations (version) VALUES ('20140215171138');

INSERT INTO schema_migrations (version) VALUES ('20140215172453');

INSERT INTO schema_migrations (version) VALUES ('20140217101235');

INSERT INTO schema_migrations (version) VALUES ('20140217220013');

INSERT INTO schema_migrations (version) VALUES ('20140217225305');

INSERT INTO schema_migrations (version) VALUES ('20140219181436');

INSERT INTO schema_migrations (version) VALUES ('20140219182606');

INSERT INTO schema_migrations (version) VALUES ('20140219183948');

INSERT INTO schema_migrations (version) VALUES ('20140219224108');

INSERT INTO schema_migrations (version) VALUES ('20140219224929');

INSERT INTO schema_migrations (version) VALUES ('20140221201441');

INSERT INTO schema_migrations (version) VALUES ('20140221235003');

INSERT INTO schema_migrations (version) VALUES ('20140221235123');

INSERT INTO schema_migrations (version) VALUES ('20140223220029');

INSERT INTO schema_migrations (version) VALUES ('20140224191436');

INSERT INTO schema_migrations (version) VALUES ('20140224232133');

INSERT INTO schema_migrations (version) VALUES ('20140225214536');

INSERT INTO schema_migrations (version) VALUES ('20140303173633');

INSERT INTO schema_migrations (version) VALUES ('20140304095259');

INSERT INTO schema_migrations (version) VALUES ('20140305054147');

INSERT INTO schema_migrations (version) VALUES ('20140307055818');

INSERT INTO schema_migrations (version) VALUES ('20140310235001');

INSERT INTO schema_migrations (version) VALUES ('20140311180338');

INSERT INTO schema_migrations (version) VALUES ('20140311185802');

INSERT INTO schema_migrations (version) VALUES ('20140311224221');

INSERT INTO schema_migrations (version) VALUES ('20140313110634');

INSERT INTO schema_migrations (version) VALUES ('20140315081148');

INSERT INTO schema_migrations (version) VALUES ('20140318080838');
