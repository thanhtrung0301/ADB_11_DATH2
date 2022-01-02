-- Index
create index idx_SPname on SanPham (TenSP)

create index idx_KHname on KhachHang (HoTen)

create index idx_TKKhachHang on TK_KhachHang(TenDangNhap, MatKhau)



-- Truy vấn
select *
from TK_KhachHang tkkh, KhachHang kh
where tkkh.MaKH = kh.MaKH and tkkh.TenDangNhap ='I2773' and tkkh.MatKhau ='319'


select hd.maHD, hd.TongTien
from HoaDon hd, KhachHang kh
where hd.maKh = kh.maKH and kh.HoTen = 'Terri Day'


select *
from SanPham sp
where sp.TenSP = 'Cipzapar'
