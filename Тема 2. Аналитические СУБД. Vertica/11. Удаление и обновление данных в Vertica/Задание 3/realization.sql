CREATE TABLE members_inc LIKE members INCLUDING PROJECTIONS;

truncate table members_inc;
copy members_inc (id, age, gender, email enforcelength)
    from local '/Users/ivan/dev/s6-lessons/Тема 2. Аналитические СУБД. Vertica/11. Удаление и обновление данных в Vertica/Задание 3/members_inc.csv'
    delimiter ';'
    rejected data as table members_rej;


merge into members t
using
    members_inc s
on t.id = s.id
when matched and (
            t.gender <> s.gender
        or t.email <> s.email
        or t.age <> s.age)
    then
    update
    set age    = s.age,
        gender = s.gender,
        email  = s.email
when not matched then
    insert (id, age, gender, email)
    values (s.id, s.age, s.gender, s.email);