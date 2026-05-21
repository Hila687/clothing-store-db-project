--
-- PostgreSQL database dump
--

-- Dumped from database version 15.7
-- Dumped by pg_dump version 16.3

-- Started on 2026-05-20 12:11:20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 242 (class 1259 OID 25925)
-- Name: advertising_campaign; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.advertising_campaign (
    campaign_id integer NOT NULL,
    director_id integer,
    campaign_name character varying(255),
    start_date date,
    end_date date,
    budget numeric(15,2),
    status_id integer
);


ALTER TABLE public.advertising_campaign OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 25940)
-- Name: advertising_platform; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.advertising_platform (
    platform_id integer NOT NULL,
    campaign_id integer,
    platform_name character varying(255),
    price integer,
    audience_reach integer,
    category_id integer
);


ALTER TABLE public.advertising_platform OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 25725)
-- Name: branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branch (
    branch_id integer NOT NULL,
    branch_name character varying(100) NOT NULL,
    branch_status character varying(50),
    phone_number character varying(20),
    opening_date date,
    city_id integer,
    manager_name character varying(255),
    opening_hours character varying(255)
);


ALTER TABLE public.branch OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 25728)
-- Name: branch_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.branch_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.branch_branch_id_seq OWNER TO postgres;

--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 215
-- Name: branch_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_branch_id_seq OWNED BY public.branch.branch_id;


--
-- TOC entry 245 (class 1259 OID 25965)
-- Name: campaign_branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaign_branch (
    campaign_id integer NOT NULL,
    branch_id integer NOT NULL
);


ALTER TABLE public.campaign_branch OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 25980)
-- Name: campaign_customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaign_customer (
    campaign_id integer NOT NULL,
    customer_id integer NOT NULL
);


ALTER TABLE public.campaign_customer OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 25898)
-- Name: campaign_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campaign_status (
    status_id integer NOT NULL,
    status_name character varying(255) NOT NULL
);


ALTER TABLE public.campaign_status OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 25729)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    category_id integer NOT NULL,
    category_name character varying(50) NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25732)
-- Name: category_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.category_category_id_seq OWNER TO postgres;

--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 217
-- Name: category_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_category_id_seq OWNED BY public.category.category_id;


--
-- TOC entry 218 (class 1259 OID 25733)
-- Name: city; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.city (
    city_id integer NOT NULL,
    city_name character varying(100) NOT NULL
);


ALTER TABLE public.city OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25736)
-- Name: city_city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.city_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.city_city_id_seq OWNER TO postgres;

--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 219
-- Name: city_city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.city_city_id_seq OWNED BY public.city.city_id;


--
-- TOC entry 220 (class 1259 OID 25737)
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    customer_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    phone_number character varying(20),
    email character varying(100),
    join_date date,
    customer_status character varying(50),
    preferences json,
    city_id integer,
    date_of_birth date,
    points_balance integer,
    loyalty_id integer
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 25742)
-- Name: customer_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_customer_id_seq OWNER TO postgres;

--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 221
-- Name: customer_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_customer_id_seq OWNED BY public.customer.customer_id;


--
-- TOC entry 222 (class 1259 OID 25743)
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    employee_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    phone_number character varying(20),
    email character varying(100),
    salary numeric(10,2),
    role character varying(50),
    hire_date date,
    branch_id integer
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 25746)
-- Name: employee_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_employee_id_seq OWNER TO postgres;

--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 223
-- Name: employee_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_employee_id_seq OWNED BY public.employee.employee_id;


--
-- TOC entry 224 (class 1259 OID 25747)
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory (
    inventory_id integer NOT NULL,
    quantity_in_stock integer,
    color character varying(50),
    size character varying(20),
    shelf_location character varying(50),
    min_stock_level integer,
    last_restock_date date,
    branch_id integer,
    product_id integer
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 25750)
-- Name: inventory_inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_inventory_id_seq OWNER TO postgres;

--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 225
-- Name: inventory_inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_inventory_id_seq OWNED BY public.inventory.inventory_id;


--
-- TOC entry 239 (class 1259 OID 25903)
-- Name: loyalty_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loyalty_level (
    loyalty_id integer NOT NULL,
    level_name character varying(255) NOT NULL
);


ALTER TABLE public.loyalty_level OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 25913)
-- Name: marketing_management; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marketing_management (
    director_id integer NOT NULL,
    director_name character varying(255) NOT NULL,
    head_office character varying(255),
    employee_count integer,
    annual_budget numeric(15,2),
    strategy_id integer
);


ALTER TABLE public.marketing_management OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 25751)
-- Name: paymentmethod; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paymentmethod (
    payment_method_id integer NOT NULL,
    payment_method_name character varying(50) NOT NULL
);


ALTER TABLE public.paymentmethod OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25754)
-- Name: paymentmethod_payment_method_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paymentmethod_payment_method_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paymentmethod_payment_method_id_seq OWNER TO postgres;

--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 227
-- Name: paymentmethod_payment_method_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paymentmethod_payment_method_id_seq OWNED BY public.paymentmethod.payment_method_id;


--
-- TOC entry 240 (class 1259 OID 25908)
-- Name: platform_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.platform_category (
    category_id integer NOT NULL,
    category_name character varying(255) NOT NULL
);


ALTER TABLE public.platform_category OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 25755)
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    product_id integer NOT NULL,
    product_name character varying(100) NOT NULL,
    brand character varying(50),
    target_audience character varying(50),
    base_price numeric(10,2),
    product_status character varying(50),
    extra_attributes json,
    supplier_id integer,
    season_id integer,
    category_id integer
);


ALTER TABLE public.product OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25760)
-- Name: product_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_product_id_seq OWNER TO postgres;

--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 229
-- Name: product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_product_id_seq OWNED BY public.product.product_id;


--
-- TOC entry 244 (class 1259 OID 25955)
-- Name: promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion (
    promo_id integer NOT NULL,
    campaign_id integer,
    promo_name character varying(255),
    discount_percent integer,
    valid_from date,
    valid_to date
);


ALTER TABLE public.promotion OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 25995)
-- Name: promotion_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_product (
    promo_id integer NOT NULL,
    product_id integer NOT NULL
);


ALTER TABLE public.promotion_product OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 25761)
-- Name: sale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sale (
    sale_id integer NOT NULL,
    sale_date date,
    total_amount numeric(10,2),
    sale_status character varying(50),
    receipt_number character varying(50),
    customer_id integer,
    employee_id integer,
    branch_id integer,
    payment_method_id integer,
    campaign_id integer,
    promo_id integer
);


ALTER TABLE public.sale OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 25764)
-- Name: sale_inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sale_inventory (
    sale_id integer NOT NULL,
    inventory_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2),
    discount_percent numeric(5,2),
    final_price numeric(10,2),
    item_status character varying(50)
);


ALTER TABLE public.sale_inventory OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 25767)
-- Name: sale_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sale_sale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sale_sale_id_seq OWNER TO postgres;

--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 232
-- Name: sale_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sale_sale_id_seq OWNED BY public.sale.sale_id;


--
-- TOC entry 233 (class 1259 OID 25768)
-- Name: season; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.season (
    season_id integer NOT NULL,
    season_name character varying(50) NOT NULL
);


ALTER TABLE public.season OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 25771)
-- Name: season_season_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.season_season_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.season_season_id_seq OWNER TO postgres;

--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 234
-- Name: season_season_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.season_season_id_seq OWNED BY public.season.season_id;


--
-- TOC entry 237 (class 1259 OID 25893)
-- Name: strategy_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.strategy_type (
    strategy_id integer NOT NULL,
    strategy_name character varying(255) NOT NULL
);


ALTER TABLE public.strategy_type OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 25772)
-- Name: supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier (
    supplier_id integer NOT NULL,
    supplier_name character varying(100) NOT NULL,
    contact_person character varying(100),
    phone_number character varying(20),
    email character varying(100),
    supplier_status character varying(50),
    contract_start_date date,
    city_id integer
);


ALTER TABLE public.supplier OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 25775)
-- Name: supplier_supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supplier_supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.supplier_supplier_id_seq OWNER TO postgres;

--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 236
-- Name: supplier_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supplier_supplier_id_seq OWNED BY public.supplier.supplier_id;


--
-- TOC entry 3271 (class 2604 OID 25776)
-- Name: branch branch_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch ALTER COLUMN branch_id SET DEFAULT nextval('public.branch_branch_id_seq'::regclass);


--
-- TOC entry 3272 (class 2604 OID 25777)
-- Name: category category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN category_id SET DEFAULT nextval('public.category_category_id_seq'::regclass);


--
-- TOC entry 3273 (class 2604 OID 25778)
-- Name: city city_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city ALTER COLUMN city_id SET DEFAULT nextval('public.city_city_id_seq'::regclass);


--
-- TOC entry 3274 (class 2604 OID 25779)
-- Name: customer customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer ALTER COLUMN customer_id SET DEFAULT nextval('public.customer_customer_id_seq'::regclass);


--
-- TOC entry 3275 (class 2604 OID 25780)
-- Name: employee employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee ALTER COLUMN employee_id SET DEFAULT nextval('public.employee_employee_id_seq'::regclass);


--
-- TOC entry 3276 (class 2604 OID 25781)
-- Name: inventory inventory_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory ALTER COLUMN inventory_id SET DEFAULT nextval('public.inventory_inventory_id_seq'::regclass);


--
-- TOC entry 3277 (class 2604 OID 25782)
-- Name: paymentmethod payment_method_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paymentmethod ALTER COLUMN payment_method_id SET DEFAULT nextval('public.paymentmethod_payment_method_id_seq'::regclass);


--
-- TOC entry 3278 (class 2604 OID 25783)
-- Name: product product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN product_id SET DEFAULT nextval('public.product_product_id_seq'::regclass);


--
-- TOC entry 3279 (class 2604 OID 25784)
-- Name: sale sale_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale ALTER COLUMN sale_id SET DEFAULT nextval('public.sale_sale_id_seq'::regclass);


--
-- TOC entry 3280 (class 2604 OID 25785)
-- Name: season season_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.season ALTER COLUMN season_id SET DEFAULT nextval('public.season_season_id_seq'::regclass);


--
-- TOC entry 3281 (class 2604 OID 25786)
-- Name: supplier supplier_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier ALTER COLUMN supplier_id SET DEFAULT nextval('public.supplier_supplier_id_seq'::regclass);


--
-- TOC entry 3320 (class 2606 OID 25929)
-- Name: advertising_campaign advertising_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertising_campaign
    ADD CONSTRAINT advertising_campaign_pkey PRIMARY KEY (campaign_id);


--
-- TOC entry 3322 (class 2606 OID 25944)
-- Name: advertising_platform advertising_platform_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertising_platform
    ADD CONSTRAINT advertising_platform_pkey PRIMARY KEY (platform_id);


--
-- TOC entry 3283 (class 2606 OID 25788)
-- Name: branch branch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pkey PRIMARY KEY (branch_id);


--
-- TOC entry 3326 (class 2606 OID 25969)
-- Name: campaign_branch campaign_branch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_branch
    ADD CONSTRAINT campaign_branch_pkey PRIMARY KEY (campaign_id, branch_id);


--
-- TOC entry 3328 (class 2606 OID 25984)
-- Name: campaign_customer campaign_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_customer
    ADD CONSTRAINT campaign_customer_pkey PRIMARY KEY (campaign_id, customer_id);


--
-- TOC entry 3312 (class 2606 OID 25902)
-- Name: campaign_status campaign_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_status
    ADD CONSTRAINT campaign_status_pkey PRIMARY KEY (status_id);


--
-- TOC entry 3285 (class 2606 OID 25790)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);


--
-- TOC entry 3287 (class 2606 OID 25792)
-- Name: city city_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (city_id);


--
-- TOC entry 3289 (class 2606 OID 25794)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 3291 (class 2606 OID 25796)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 3294 (class 2606 OID 25798)
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);


--
-- TOC entry 3314 (class 2606 OID 25907)
-- Name: loyalty_level loyalty_level_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loyalty_level
    ADD CONSTRAINT loyalty_level_pkey PRIMARY KEY (loyalty_id);


--
-- TOC entry 3318 (class 2606 OID 25919)
-- Name: marketing_management marketing_management_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marketing_management
    ADD CONSTRAINT marketing_management_pkey PRIMARY KEY (director_id);


--
-- TOC entry 3296 (class 2606 OID 25800)
-- Name: paymentmethod paymentmethod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paymentmethod
    ADD CONSTRAINT paymentmethod_pkey PRIMARY KEY (payment_method_id);


--
-- TOC entry 3316 (class 2606 OID 25912)
-- Name: platform_category platform_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform_category
    ADD CONSTRAINT platform_category_pkey PRIMARY KEY (category_id);


--
-- TOC entry 3298 (class 2606 OID 25802)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- TOC entry 3324 (class 2606 OID 25959)
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (promo_id);


--
-- TOC entry 3330 (class 2606 OID 25999)
-- Name: promotion_product promotion_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_product
    ADD CONSTRAINT promotion_product_pkey PRIMARY KEY (promo_id, product_id);


--
-- TOC entry 3304 (class 2606 OID 25804)
-- Name: sale_inventory sale_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_inventory
    ADD CONSTRAINT sale_inventory_pkey PRIMARY KEY (sale_id, inventory_id);


--
-- TOC entry 3302 (class 2606 OID 25806)
-- Name: sale sale_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT sale_pkey PRIMARY KEY (sale_id);


--
-- TOC entry 3306 (class 2606 OID 25808)
-- Name: season season_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.season
    ADD CONSTRAINT season_pkey PRIMARY KEY (season_id);


--
-- TOC entry 3310 (class 2606 OID 25897)
-- Name: strategy_type strategy_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.strategy_type
    ADD CONSTRAINT strategy_type_pkey PRIMARY KEY (strategy_id);


--
-- TOC entry 3308 (class 2606 OID 25810)
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (supplier_id);


--
-- TOC entry 3292 (class 1259 OID 25811)
-- Name: idx_inventory_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inventory_product_id ON public.inventory USING btree (product_id);


--
-- TOC entry 3299 (class 1259 OID 25812)
-- Name: idx_sale_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sale_customer_id ON public.sale USING btree (customer_id);


--
-- TOC entry 3300 (class 1259 OID 25813)
-- Name: idx_sale_sale_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sale_sale_date ON public.sale USING btree (sale_date);


--
-- TOC entry 3331 (class 2606 OID 25814)
-- Name: branch fk_branch_city; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT fk_branch_city FOREIGN KEY (city_id) REFERENCES public.city(city_id);


--
-- TOC entry 3350 (class 2606 OID 25930)
-- Name: advertising_campaign fk_campaign_director; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertising_campaign
    ADD CONSTRAINT fk_campaign_director FOREIGN KEY (director_id) REFERENCES public.marketing_management(director_id);


--
-- TOC entry 3351 (class 2606 OID 25935)
-- Name: advertising_campaign fk_campaign_status; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertising_campaign
    ADD CONSTRAINT fk_campaign_status FOREIGN KEY (status_id) REFERENCES public.campaign_status(status_id);


--
-- TOC entry 3355 (class 2606 OID 25975)
-- Name: campaign_branch fk_cb_branch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_branch
    ADD CONSTRAINT fk_cb_branch FOREIGN KEY (branch_id) REFERENCES public.branch(branch_id);


--
-- TOC entry 3356 (class 2606 OID 25970)
-- Name: campaign_branch fk_cb_campaign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_branch
    ADD CONSTRAINT fk_cb_campaign FOREIGN KEY (campaign_id) REFERENCES public.advertising_campaign(campaign_id);


--
-- TOC entry 3357 (class 2606 OID 25985)
-- Name: campaign_customer fk_cc_campaign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_customer
    ADD CONSTRAINT fk_cc_campaign FOREIGN KEY (campaign_id) REFERENCES public.advertising_campaign(campaign_id);


--
-- TOC entry 3358 (class 2606 OID 25990)
-- Name: campaign_customer fk_cc_customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campaign_customer
    ADD CONSTRAINT fk_cc_customer FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- TOC entry 3332 (class 2606 OID 25819)
-- Name: customer fk_customer_city; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT fk_customer_city FOREIGN KEY (city_id) REFERENCES public.city(city_id);


--
-- TOC entry 3333 (class 2606 OID 26010)
-- Name: customer fk_customer_loyalty; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT fk_customer_loyalty FOREIGN KEY (loyalty_id) REFERENCES public.loyalty_level(loyalty_id);


--
-- TOC entry 3334 (class 2606 OID 25824)
-- Name: employee fk_employee_branch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT fk_employee_branch FOREIGN KEY (branch_id) REFERENCES public.branch(branch_id);


--
-- TOC entry 3335 (class 2606 OID 25829)
-- Name: inventory fk_inventory_branch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT fk_inventory_branch FOREIGN KEY (branch_id) REFERENCES public.branch(branch_id);


--
-- TOC entry 3336 (class 2606 OID 25834)
-- Name: inventory fk_inventory_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- TOC entry 3352 (class 2606 OID 25945)
-- Name: advertising_platform fk_platform_campaign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertising_platform
    ADD CONSTRAINT fk_platform_campaign FOREIGN KEY (campaign_id) REFERENCES public.advertising_campaign(campaign_id);


--
-- TOC entry 3353 (class 2606 OID 25950)
-- Name: advertising_platform fk_platform_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertising_platform
    ADD CONSTRAINT fk_platform_category FOREIGN KEY (category_id) REFERENCES public.platform_category(category_id);


--
-- TOC entry 3359 (class 2606 OID 26005)
-- Name: promotion_product fk_pp_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_product
    ADD CONSTRAINT fk_pp_product FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- TOC entry 3360 (class 2606 OID 26000)
-- Name: promotion_product fk_pp_promotion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_product
    ADD CONSTRAINT fk_pp_promotion FOREIGN KEY (promo_id) REFERENCES public.promotion(promo_id);


--
-- TOC entry 3337 (class 2606 OID 25839)
-- Name: product fk_product_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES public.category(category_id);


--
-- TOC entry 3338 (class 2606 OID 25844)
-- Name: product fk_product_season; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_season FOREIGN KEY (season_id) REFERENCES public.season(season_id);


--
-- TOC entry 3339 (class 2606 OID 25849)
-- Name: product fk_product_supplier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_supplier FOREIGN KEY (supplier_id) REFERENCES public.supplier(supplier_id);


--
-- TOC entry 3354 (class 2606 OID 25960)
-- Name: promotion fk_promotion_campaign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT fk_promotion_campaign FOREIGN KEY (campaign_id) REFERENCES public.advertising_campaign(campaign_id);


--
-- TOC entry 3340 (class 2606 OID 25854)
-- Name: sale fk_sale_branch; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT fk_sale_branch FOREIGN KEY (branch_id) REFERENCES public.branch(branch_id);


--
-- TOC entry 3341 (class 2606 OID 26017)
-- Name: sale fk_sale_campaign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT fk_sale_campaign FOREIGN KEY (campaign_id) REFERENCES public.advertising_campaign(campaign_id);


--
-- TOC entry 3342 (class 2606 OID 25859)
-- Name: sale fk_sale_customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT fk_sale_customer FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- TOC entry 3343 (class 2606 OID 25864)
-- Name: sale fk_sale_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT fk_sale_employee FOREIGN KEY (employee_id) REFERENCES public.employee(employee_id);


--
-- TOC entry 3346 (class 2606 OID 25869)
-- Name: sale_inventory fk_sale_inventory_inventory; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_inventory
    ADD CONSTRAINT fk_sale_inventory_inventory FOREIGN KEY (inventory_id) REFERENCES public.inventory(inventory_id);


--
-- TOC entry 3347 (class 2606 OID 25874)
-- Name: sale_inventory fk_sale_inventory_sale; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_inventory
    ADD CONSTRAINT fk_sale_inventory_sale FOREIGN KEY (sale_id) REFERENCES public.sale(sale_id);


--
-- TOC entry 3344 (class 2606 OID 25879)
-- Name: sale fk_sale_payment_method; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT fk_sale_payment_method FOREIGN KEY (payment_method_id) REFERENCES public.paymentmethod(payment_method_id);


--
-- TOC entry 3345 (class 2606 OID 26022)
-- Name: sale fk_sale_promotion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale
    ADD CONSTRAINT fk_sale_promotion FOREIGN KEY (promo_id) REFERENCES public.promotion(promo_id);


--
-- TOC entry 3349 (class 2606 OID 25920)
-- Name: marketing_management fk_strategy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marketing_management
    ADD CONSTRAINT fk_strategy FOREIGN KEY (strategy_id) REFERENCES public.strategy_type(strategy_id);


--
-- TOC entry 3348 (class 2606 OID 25884)
-- Name: supplier fk_supplier_city; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT fk_supplier_city FOREIGN KEY (city_id) REFERENCES public.city(city_id);


-- Completed on 2026-05-20 12:11:21

--
-- PostgreSQL database dump complete
--

