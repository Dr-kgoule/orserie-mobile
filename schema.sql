-- ORSERIE : à coller dans Supabase > SQL Editor > Run
create table if not exists categories(id bigint generated always as identity primary key,title text not null,description text default '',position int default 0,created_at timestamptz default now());
create table if not exists designs(id bigint generated always as identity primary key,category_id bigint references categories(id) on delete cascade,image_url text not null,label text default '',created_at timestamptz default now());
create table if not exists prices(id bigint generated always as identity primary key,item text not null,quality text default '',weight text default '',price int not null,position int default 0);
create table if not exists settings(key text primary key,value text);
alter table categories enable row level security;alter table designs enable row level security;alter table prices enable row level security;alter table settings enable row level security;
do $$ declare t text; begin foreach t in array array['categories','designs','prices','settings'] loop
 execute format('create policy "lecture publique" on %I for select using (true)',t);
 execute format('create policy "ecriture admin" on %I for all to authenticated using (true) with check (true)',t);
end loop; end $$;
insert into storage.buckets(id,name,public) values('designs','designs',true) on conflict do nothing;
create policy "images publiques" on storage.objects for select using (bucket_id='designs');
create policy "images admin" on storage.objects for all to authenticated using (bucket_id='designs') with check (bucket_id='designs');
insert into settings values('wa','8619568722354'),('email','originalorserie@cloud.com'),('note','Livraison Chine–Gabon : 2 000 FCFA. Achats non remboursables, mais échangeables.') on conflict do nothing;
insert into categories(title,description,position) values('World','Villes, pays, continents — des paysages du monde sur tes vêtements.',1),('Custom','On redonne vie à tes vêtements en les redessinant entièrement.',2),('Sur mesure','Une idée précise ? Écris-nous, on la rend portable.',3);
insert into prices(item,quality,weight,price,position) values('T-shirt','Haute','300g',12000,1),('Pull-over','Haute','600g',17000,2),('Ensemble','Haute','1,2kg',25000,3),('Babouche','Haute','450g',8000,4),('Casquette','Haute','200g',8000,5),('Chaussettes','Haute','80g',1000,6),('T-shirt','Moyenne','260g',8000,7),('Pull-over','Moyenne','450g',12000,8),('Ensemble','Moyenne','900g',19000,9);
