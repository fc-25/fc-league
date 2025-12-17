/*
  # إصلاح RLS Policies

  تحديث السياسات لاستخدام anon بدل public، وضمان أن جميع التسجيلات تسمح بالإدراج من المستخدمين بدون تسجيل
*/

-- Drop old policies that use "public"
DROP POLICY IF EXISTS "Anyone can view registrations" ON registrations;
DROP POLICY IF EXISTS "Anyone can insert registrations" ON registrations;

-- Create new policies for registrations with anon role
CREATE POLICY "Anon can view registrations"
  ON registrations FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Anon can insert registrations"
  ON registrations FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Public can view registrations"
  ON registrations FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Public can insert registrations"
  ON registrations FOR INSERT
  TO public
  WITH CHECK (true);

-- Fix other tables' policies similarly
DROP POLICY IF EXISTS "Anyone can view tournaments" ON tournaments;
DROP POLICY IF EXISTS "Anyone can view participants" ON tournament_participants;
DROP POLICY IF EXISTS "Anyone can view league matches" ON league_matches;
DROP POLICY IF EXISTS "Anyone can view league standings" ON league_standings;
DROP POLICY IF EXISTS "Anyone can view knockout matches" ON knockout_matches;

CREATE POLICY "Anon can view tournaments" ON tournaments FOR SELECT TO anon USING (true);
CREATE POLICY "Public can view tournaments" ON tournaments FOR SELECT TO public USING (true);

CREATE POLICY "Anon can view participants" ON tournament_participants FOR SELECT TO anon USING (true);
CREATE POLICY "Public can view participants" ON tournament_participants FOR SELECT TO public USING (true);

CREATE POLICY "Anon can view league matches" ON league_matches FOR SELECT TO anon USING (true);
CREATE POLICY "Public can view league matches" ON league_matches FOR SELECT TO public USING (true);

CREATE POLICY "Anon can view league standings" ON league_standings FOR SELECT TO anon USING (true);
CREATE POLICY "Public can view league standings" ON league_standings FOR SELECT TO public USING (true);

CREATE POLICY "Anon can view knockout matches" ON knockout_matches FOR SELECT TO anon USING (true);
CREATE POLICY "Public can view knockout matches" ON knockout_matches FOR SELECT TO public USING (true);
