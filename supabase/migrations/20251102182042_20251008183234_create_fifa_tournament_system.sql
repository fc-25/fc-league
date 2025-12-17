/*
  # نظام بطولات فيفا 26 - قاعدة البيانات الكاملة

  1. الجداول الجديدة: tournaments, registrations, tournament_participants, league_matches, league_standings, knockout_matches
  2. تفعيل RLS على جميع الجداول
  3. إدراج بيانات البطولات الأولية
*/

-- Create tournaments table
CREATE TABLE IF NOT EXISTS tournaments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  type text NOT NULL CHECK (type IN ('league', 'online', 'offline')),
  max_participants integer NOT NULL DEFAULT 16,
  status text NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'playing', 'closed')),
  start_date timestamptz,
  end_date timestamptz,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view tournaments"
  ON tournaments FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can manage tournaments"
  ON tournaments FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Create registrations table
CREATE TABLE IF NOT EXISTS registrations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  player_name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  tournament_type text NOT NULL CHECK (tournament_type IN ('league', 'online', 'offline')),
  experience_level text NOT NULL CHECK (experience_level IN ('beginner', 'intermediate', 'advanced', 'professional')),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE registrations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view registrations"
  ON registrations FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Anyone can insert registrations"
  ON registrations FOR INSERT
  TO public
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update registrations"
  ON registrations FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Create tournament_participants table
CREATE TABLE IF NOT EXISTS tournament_participants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tournament_id uuid REFERENCES tournaments(id) ON DELETE CASCADE,
  registration_id uuid REFERENCES registrations(id) ON DELETE CASCADE,
  team_name text NOT NULL,
  seed integer,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE tournament_participants ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view participants"
  ON tournament_participants FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can manage participants"
  ON tournament_participants FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Create league_matches table
CREATE TABLE IF NOT EXISTS league_matches (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  team1_name text NOT NULL,
  team2_name text NOT NULL,
  team1_score integer,
  team2_score integer,
  match_date timestamptz DEFAULT now(),
  week integer DEFAULT 1,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE league_matches ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view league matches"
  ON league_matches FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can manage league matches"
  ON league_matches FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Create league_standings table
CREATE TABLE IF NOT EXISTS league_standings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  team_name text UNIQUE NOT NULL,
  matches_played integer DEFAULT 0,
  wins integer DEFAULT 0,
  draws integer DEFAULT 0,
  losses integer DEFAULT 0,
  goals_for integer DEFAULT 0,
  goals_against integer DEFAULT 0,
  goal_difference integer DEFAULT 0,
  points integer DEFAULT 0,
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE league_standings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view league standings"
  ON league_standings FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can manage league standings"
  ON league_standings FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Create knockout_matches table
CREATE TABLE IF NOT EXISTS knockout_matches (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tournament_type text NOT NULL CHECK (tournament_type IN ('online', 'offline')),
  round integer NOT NULL,
  match_number integer,
  team1_name text NOT NULL,
  team2_name text NOT NULL,
  team1_score integer,
  team2_score integer,
  winner_name text,
  match_date timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE knockout_matches ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view knockout matches"
  ON knockout_matches FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can manage knockout matches"
  ON knockout_matches FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Insert initial tournament data
INSERT INTO tournaments (name, type, max_participants, status) VALUES
  ('بطولة الدوري الممتاز', 'league', 16, 'open'),
  ('كأس فيفا الرقمي', 'online', 32, 'open'),
  ('بطولة الأبطال الحضورية', 'offline', 16, 'open')
ON CONFLICT DO NOTHING;
