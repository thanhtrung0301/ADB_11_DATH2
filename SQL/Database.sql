create database QLCH
go
use QLCH
go


create table NhaCungCap
(
	MaNCC varchar(10) primary key,
	TenNCC nvarchar(20),
	SoDienThoai varchar(11),
	DiaChi nvarchar(20),
	Email varchar(20)
)


create table PhieuDatHang
(
	MaPDH varchar(10) primary key,
	NgayDat datetime,
	PhiGiaoHang int,
	PhiSanPham int,
	HinhThucThanhToan nvarchar(20),
	MaNCC varchar(10),
	QuanTri varchar(10)
)


create table CT_PhieuDatHang
(
	MaPDH varchar(10),
	MaSP varchar(10),
	GiaCungCap int,
	SoLuong int
	primary key(MaPDH,MaSP)
)



create table KhachHang
(
	MaKH varchar(10) primary key,
	HoTen nvarchar(20),
	SoDienThoai char(11),
	DiaChi nvarchar(20),
	Email char(20)
)


create table TK_KhachHang
(
	ID varchar(10) primary key,
	MaKH varchar(10),
	TenDangNhap varchar(15),
	MatKhau varchar(15)
)


create table HoaDon
(
	MaHD varchar(10) primary key,
	PhiGiaoHang int,
	PhiSanPham int,
	HinhThucThanhToan nvarchar(20),
	MaKH varchar(10),
	MaNV varchar(10),
	TongTien int
)



create table CT_HoaDon
(
	MaHD varchar(10),
	MaSP varchar(10),
	GiaBan int,
	SoLuong int
	primary key(MaHD,MaSP)
)


create table SanPham
(
	MaSP varchar(10) primary key,
	TenSP varchar(20),
)


create table NhanVien
(
	MaNV varchar(10) primary key,
	HoTen nvarchar(20),
	CMND char(9),
	SoDienThoai varchar(11),
	DiaChi nvarchar(20),
	Email varchar(20)
)



alter table CT_HoaDon add constraint FK_CTHoaDon_HoaDon foreign key (MaHD) references HoaDon(MaHD)
alter table CT_HoaDon add constraint FK_CTHoaDon_SanPham foreign key (MaSP) references SanPham(MaSP)
alter table CT_PhieuDatHang add constraint FK_CTPhieuDatHang_PhieuDatHang foreign key (MaPDH) references PhieuDatHang(MaPDH)
alter table CT_PhieuDatHang add constraint FK_CTPhieuDatHang_SanPham foreign key (MaSP) references SanPham(MaSP)
alter table PhieuDatHang add constraint FK_PhieuDatHang_NhaCungCap foreign key (MaNCC) references NhaCungCap(MaNCC)
alter table HoaDon add constraint FK_HoaDon_KhachHang foreign key (MaKH) references KhachHang(MaKH)
alter table HoaDon add constraint FK_HoaDon_NhanVien foreign key (MaNV) references NhanVien(MaNV)
alter table PhieuDatHang add constraint FK_PhieuDatHang_NhanVien foreign key (QuanTri) references NhanVien(MaNV)
alter table NhanVien add constraint UC_NhanVien unique(CMND)
alter table TK_KhachHang add constraint FK_TKKhachHang_KhachHang foreign key (MaKH) references KhachHang(MaKH)
alter table TK_KhachHang add constraint UC_TKKhachHang unique(TenDangNhap)


go
create trigger insert_CTHoaDon_HoaDon on CT_HoaDon
for insert as
Begin
	declare @tongtien int

	select @tongtien = sum(cthd.GiaBan * cthd.SoLuong)
	from CT_HoaDon cthd, inserted t1
	where cthd.MaHD = t1.MaHD
	group by cthd.MaHD

	update hd set hd.TongTien = @tongtien
	from HoaDon hd, inserted t1
	where hd.MaHD = t1.MaHD
End

go
create trigger delete_CTHoaDon_HoaDon on CT_HoaDon
for delete as
Begin
	declare @tongtien int

	select @tongtien = sum(cthd.GiaBan * cthd.SoLuong)
	from CT_HoaDon cthd, deleted t2
	where cthd.MaHD = t2.MaHD
	group by cthd.MaHD

	update hd set hd.TongTien = @tongtien
	from HoaDon hd, deleted t2
	where hd.MaHD = t2.MaHD
End

go
create trigger update_CTHoaDon_HoaDon on CT_HoaDon
for update as
Begin
	declare @tongtien int

	select @tongtien = sum(cthd.GiaBan * cthd.SoLuong)
	from CT_HoaDon cthd,inserted t1
	where cthd.MaHD = t1.MaHD
	group by cthd.MaHD

	update hd set hd.TongTien = @tongtien
	from HoaDon hd, inserted t1
	where hd.MaHD = t1.MaHD

	select @tongtien = sum(cthd.GiaBan * cthd.SoLuong)
	from CT_HoaDon cthd, deleted t2
	where cthd.MaHD = t2.MaHD
	group by cthd.MaHD

	update hd set hd.TongTien = @tongtien
	from HoaDon hd, deleted t2
	where hd.MaHD = t2.MaHD
End
go
