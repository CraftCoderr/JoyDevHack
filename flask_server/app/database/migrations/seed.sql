
insert into dictionary.users (
		id,
    name ,
    surname ,
    email ,
    phone,
    token_expired_at) values
('a9b23cde-bb67-11eb-992b-bb4877356bd3', 'Lena', 'Kaida', 'elenanikolaevna999@yandex.ru', '7978711111111', now() + interval '100 min'),
('a9b23cde-bb67-11eb-992b-bb4877356bd1', 'Vlad', 'Stelmah', 'vlad@yandex.ru', '7978711111112', now() + interval '100 min');