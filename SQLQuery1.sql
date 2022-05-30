create database Library
use Library

create table Authors
(
	Id int primary key identity,
	Name nvarchar(25),
	Surname nvarchar(30)
)

insert into Authors
values ('Mammad','Mammadli'),
('Ali','Aliyev'),
('Vali','Valiyev'),
('Vuqar','Valiyev')

create table Books
(
	Id int primary key identity,
	Name nvarchar(100) constraint ch_Name check(len(Name)>1),
	Author_Id int foreign key references Authors(Id),
	Page_Count int constraint ch_Page_Count check(Page_Count>9)
)

insert into Books
values ('Book1',1,300),
('Book2',2,55),
('Book3',3,667),
('Book4',1,67),
('Book5',1,88),
('Book6',2,678)

--- Books ve Authors table-lariniz olsun (one to many realtion) Id,Name,PageCount ve AuthorFullName columnlarinin valuelarini qaytaran bir view yaradin ---
create view vw_1
as
select b.Id, b.Name, b.Page_Count, a.Name+' '+a.Surname as Fullname from Books as b
join Authors as a on b.Author_Id=a.Id

select * from vw_1

--- Gonderilmis axtaris deyirene gore hemin axtaris deyeri name ve ya authorFullNamelerinde olan Book-lari Id,Name,PageCount,AuthorFullName columnlari seklinde gostern procedure yazin ---
create procedure pr_1
@search nvarchar(100)
as
select b.Id, b.Name, b.Page_Count, a.Name+' '+a.Surname as Fullname from Books as b
join Authors as a on b.Author_Id=a.Id where b.Name like '%'+@search+'%' or a.Name like '%'+@search+'%' or a.Surname like '%'+@search+'%';

exec pr_1 mamma

--- Authors tableinin insert,update ve deleti ucun (her biri ucun ayrica) procedure yaradin ---
--- insert ---
create procedure pr_insert
@Name nvarchar(25),
@Surname nvarchar(30)
as
insert into Authors
values (@Name,@Surname)

exec pr_insert 'Saleh','Salehli'

--- update ---
create procedure pr_update
@id int,
@Name nvarchar(25),
@Surname nvarchar(30)
as
update Authors
set Name=@Name,Surname=@Surname where id=@id

exec pr_update 1,'Saleh', 'Salehli';

--- delete ---

create procedure pr_delete
@id int
as
delete from Authors
where id=@id

exec pr_delete 4;

--- Authors-lari Id,FullName,BooksCount,MaxPageCount seklinde qaytaran view yaradirsiniz Id-author id-si, FullName - Name ve Surname birlesmesi, BooksCount - Hemin authorun elaqeli oldugu kitablarin sayi, MaxPageCount - hemin authorun elaqeli oldugu kitablarin icerisindeki max pagecount deyeri ---
create view vw_2
as
select a.Name+' '+a.Surname as Fullname, COUNT(b.Id) as 'Books Count', max(b.Page_Count) as 'Max Page Count' from Authors as a join Books as b
on a.Id=b.Author_Id group by b.Author_Id, a.Name,a.Surname;

select * from vw_2