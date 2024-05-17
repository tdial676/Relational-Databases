CALL sp_add_user('alex', 'hello');
CALL sp_add_user('bowie', 'goodbye');

SELECT authenticate('chaka', 'hello');     -- Should return 0 (false)
SELECT authenticate('alex', 'goodbye');    -- Should return 0 (false)
SELECT authenticate('alex', 'hello');      -- Should return 1 (true)
SELECT authenticate('alex', 'HELLO');      -- Should return 0 (false)
SELECT authenticate('bowie', 'goodbye');   -- Should return 1 (true)

-- provided tests for optional 1d
CALL sp_change_password('alex', 'greetings'); 

SELECT authenticate('alex', 'hello');      -- Should return 0 (false)
SELECT authenticate('alex', 'greetings');  -- Should return 1 (true)
SELECT authenticate('bowie', 'greetings'); -- Should return 0 (false)



