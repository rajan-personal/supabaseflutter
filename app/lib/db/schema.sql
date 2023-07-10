DROP TABLE IF EXISTS links;
DROP TABLE IF EXISTS members;
DROP TYPE IF EXISTS acl_enum;
DROP TABLE IF EXISTS events;



CREATE TABLE events (
  id UUID UNIQUE DEFAULT uuid_generate_v4(),
  title VARCHAR(64) NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

  PRIMARY KEY (id)
);

CREATE TYPE acl_enum AS ENUM (
  'admin',
  'editor'
);

CREATE TABLE members (
  id UUID UNIQUE DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES auth.users on delete cascade,
  event_id UUID NOT NULL REFERENCES events(id),
  acl acl_enum NOT NULL DEFAULT 'editor',
  PRIMARY KEY (id)
);

CREATE TABLE links (
  id UUID UNIQUE DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES auth.users on delete cascade,
  event_id UUID NOT NULL REFERENCES events(id),
  url VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE OR REPLACE FUNCTION event_list_acl()
RETURNS table(
  id uuid
) AS $$
BEGIN
  RETURN QUERY SELECT event_id FROM members WHERE user_id = auth.uid();
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER;

CREATE POLICY "select allowed events" ON "public"."events"
AS PERMISSIVE FOR SELECT
TO public
USING (id in (select * from event_list_acl()));

CREATE POLICY "select allowed members" ON "public"."members"
AS PERMISSIVE FOR SELECT
TO public
USING (event_id IN ( SELECT id FROM events));

CREATE POLICY "select allowed event links" ON "public"."links"
AS PERMISSIVE FOR SELECT
TO public
USING (event_id IN ( SELECT id FROM events));

CREATE OR REPLACE function add_user_on_event_insert()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into members (user_id, event_id, acl) values (auth.uid(), new.id, 'admin');
  RETURN new;
end;
$$;

CREATE OR REPLACE TRIGGER add_user_on_event_insert
AFTER INSERT
ON events
FOR EACH ROW
EXECUTE PROCEDURE add_user_on_event_insert();

alter table events enable row level security;
alter table members enable row level security;
alter table links enable row level security;


INSERT INTO events (title, location, description) VALUES
('Django Meetup', 'A monthly meetup for Django developers'),
('Python Conference', 'A two-day conference for Pythonistas'),
('Flask Workshop', 'A one-day workshop on Flask');


INSERT INTO members (user_id, event_id, acl) VALUES
('afc49dbf-3eb9-425e-b538-ff2275dea059'::UUID, 'ead8f308-f0a1-423e-a47f-126cc6988cbf'::UUID, 'admin'),
('398d9b8d-7966-4de3-842f-d12954db79d3'::UUID, 'ead8f308-f0a1-423e-a47f-126cc6988cbf'::UUID, 'editor');

INSERT INTO links (user_id, event_id, url) VALUES
('afc49dbf-3eb9-425e-b538-ff2275dea059'::UUID, 'ead8f308-f0a1-423e-a47f-126cc6988cbf'::UUID, 'https://www.djangoproject.com/'),
('afc49dbf-3eb9-425e-b538-ff2275dea059'::UUID, 'ead8f308-f0a1-423e-a47f-126cc6988cbf'::UUID, 'https://www.python.org/'),
('afc49dbf-3eb9-425e-b538-ff2275dea059'::UUID, 'ead8f308-f0a1-423e-a47f-126cc6988cbf'::UUID, 'https://flask.palletsprojects.com/'),
('398d9b8d-7966-4de3-842f-d12954db79d3'::UUID, 'ead8f308-f0a1-423e-a47f-126cc6988cbf'::UUID, 'https://www.djangoproject.com/'),
('398d9b8d-7966-4de3-842f-d12954db79d3'::UUID, 'ead8f308-f0a1-423e-a47f-126cc6988cbf'::UUID, 'https://www.python.org/'),
('398d9b8d-7966-4de3-842f-d12954db79d3'::UUID, 'ead8f308-f0a1-423e-a47f-126cc6988cbf'::UUID, 'https://flask.palletsprojects.com/');

read:
  - event
  - members
  - links

create:
  - event
  - members
  - links

update:
  - event
  - members

delete:
  - members

deactivate:
  - links