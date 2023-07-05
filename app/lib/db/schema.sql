DROP TABLE IF EXISTS links;
DROP TABLE IF EXISTS members;
DROP TYPE IF EXISTS acl_enum;
DROP TABLE IF EXISTS events;



CREATE TABLE events (
  id UUID UNIQUE DEFAULT uuid_generate_v4(),
  title VARCHAR(64) NOT NULL,
  location VARCHAR(255),
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

INSERT INTO events (title, location, description) VALUES
('Django Meetup', 'San Francisco, CA', 'A monthly meetup for Django developers'),
('Python Conference', 'New York, NY', 'A two-day conference for Pythonistas'),
('Flask Workshop', 'Austin, TX', 'A one-day workshop on Flask');


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

