-- DROP FUNCTION IF EXISTS period_amount(account_id uuid, date_from date, date_to date);
CREATE OR REPLACE FUNCTION openbill_period_amount(account_id uuid, date_from date, date_to date) RETURNS decimal AS $$;
  SELECT sum(CASE WHEN account_id = to_account_id THEN amount_cents ELSE -amount_cents END) 
  FROM openbill_transactions 
  WHERE (to_account_id = account_id OR from_account_id = account_id) AND
  ((date_from IS NULL OR created_at>=date_from) AND (date_to IS NULL OR created_at<=date_to))
$$ LANGUAGE SQL;
