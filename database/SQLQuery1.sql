﻿CREATE DATABASE QL
ON PRIMARY
(
	NAME = QL_Primary,
	Filename= 'D:\lập trình\C#\CN.Net\Đồ án\QL_Primary.mdf',
	Size=5MB,
	Maxsize=20MB,
	Filegrowth=10%
)
LOG ON
(
	NAME = QL_Log,
	Filename= 'D:\lập trình\C#\CN.Net\Đồ án\QL_Log.ldf',
	Size=5MB,
	Maxsize=10MB,
	Filegrowth=10%
);
USE QL
GO
CREATE TABLE ADMIN
(
	USENAME NCHAR(10) NOT NULL,
	PASS NCHAR(10) NOT NULL,
	QUYEN NVARCHAR(20) NOT NULL,
	CONSTRAINT PK_AD PRIMARY KEY(USENAME),
	CONSTRAINT UNI_USENAME UNIQUE(USENAME)
	
)
CREATE TABLE CHUNGLOAI
(
	MaCL NCHAR(10) NOT NULL,
	TenCL NVARCHAR(50) NOT NULL,
	DienGiai NVARCHAR(50),
	CONSTRAINT PK_ChungLoai PRIMARY KEY(MaCL),
	CONSTRAINT UNI_MACL UNIQUE(MaCL)	
)

CREATE TABLE NHOMLOAI
(
	MaNL NCHAR(10) NOT NULL,
	TenNL NVARCHAR(100) NOT NULL,
	MaCL NCHAR(10) NOT NULL,
	DienGiai NVARCHAR(50),
	CONSTRAINT PK_NhomLoai PRIMARY KEY(MaNL),
	CONSTRAINT FK_NhomLoai_ChungLoai FOREIGN KEY(MaCL) REFERENCES CHUNGLOAI(MaCL),
	CONSTRAINT UNI_MANL UNIQUE(MaNL)
)

CREATE TABLE THELOAI
(
	MaTL NCHAR(10) NOT NULL,
	TenTL NVARCHAR(100) NOT NULL,
	MaNL NCHAR(10) NOT NULL,
	DienGiai NVARCHAR(100),
	CONSTRAINT PK_TheLoai PRIMARY KEY(MaTL),
	CONSTRAINT FK_TheLoai_ChungLoai FOREIGN KEY(MaNL) REFERENCES NHOMLOAI(MaNL),
	CONSTRAINT UNI_MATL UNIQUE(MaTL)	
)

CREATE TABLE NSX
(
	MaNSX NCHAR(10) NOT NULL,
	TenNSX NVARCHAR(100) NOT NULL,
	DiaChi NVARCHAR(100) NOT NULL,
	SDT NCHAR(11),
	CONSTRAINT PK_NhaSanXuat PRIMARY KEY(MaNSX),
	CONSTRAINT UNI_MANSX UNIQUE(MaNSX)
)

CREATE TABLE NHACUNGCAP
(
	MaNCC NCHAR(10) NOT NULL,
	TenNCC NVARCHAR(100) NOT NULL,
	DiaChi NVARCHAR(100) NOT NULL,
	SDT NCHAR(11),
	CONSTRAINT PK_NhaCungCap PRIMARY KEY(MaNCC),
	CONSTRAINT UNI_MANCC UNIQUE(MaNCC)
)

CREATE TABLE NHANVIEN
(
	MaNV NCHAR(10) NOT NULL,
	TenNV NVARCHAR(80) NOT NULL,
	ChucVu NVARCHAR(50) NOT NULL,
	DiaChi NVARCHAR(50) NOT NULL,
	GioiTinh NCHAR(5),
	SDT NCHAR(10),
	CONSTRAINT PK_NhanVien PRIMARY KEY(MaNV),
	CONSTRAINT UNI_MANV UNIQUE(MaNV),
	CONSTRAINT CHK_GioiTinh_NV check(GioiTinh='Nam' or GioiTinh='Nữ')
)

CREATE TABLE KHO
(
	MaKho NCHAR(10) NOT NULL,
	TenKho NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_Kho PRIMARY KEY(MaKho),
	CONSTRAINT UNI_MaKho UNIQUE(MaKho)
)

CREATE TABLE THIETBI
(
	MaTB NCHAR(10) NOT NULL,
	TenTB NVARCHAR(100) NOT NULL,
	DVT NCHAR(50) NOT NULL,
	DVT_Max NCHAR(10) NOT NULL,
	DonGia INT NOT NULL,
	GiaNhap INT NOT NULL,
	SoLuongTon INT NOT NULL,
	NgayCapNhat DATE,
	MaTL NCHAR(10) NOT NULL,
	MaNSX NCHAR(10) NOT NULL,
	MaKho NCHAR(10) NOT NULL,
	CONSTRAINT PK_ThietBi PRIMARY KEY(MaTB),
	CONSTRAINT FK_ThietBi_TheLoai FOREIGN KEY(MaTL) REFERENCES TheLoai(MaTL),
	CONSTRAINT FK_ThietBi_NhaSanXuat FOREIGN KEY(MaNSX) REFERENCES NSX(MaNSX),
	CONSTRAINT FK_ThietBi_Kho FOREIGN KEY(MaKho) REFERENCES KHO(MaKho),
	CONSTRAINT UNI_MATB UNIQUE(MaTB),
	CONSTRAINT CHK_DonGia_ThietBi check(DonGia>=0)
)

CREATE TABLE KHACHHANG
(
	MaKH NCHAR(10) NOT NULL,
	TenKH NVARCHAR(80) NOT NULL,
	MST NVARCHAR(20) NOT NULL,
	DiaChi NVARCHAR(50) NOT NULL,
	GioiTinh NCHAR(5),
	SDT NCHAR(10),
	CONSTRAINT PK_KhachHang PRIMARY KEY(MaKH),
	CONSTRAINT UNI_MAKH UNIQUE(MaKH),
	CONSTRAINT CHK_GioiTinh_KH check(GioiTinh='Nam' or GioiTinh='Nữ')
)

CREATE TABLE HOADON
(
	SoHD NCHAR(10) NOT NULL,
	NgayLap_HD DATE NOT NULL,
	VAT NCHAR(20),
	TongGiaTri INT NOT NULL,
	MaNV NCHAR(10) NOT NULL,
	MaKH NCHAR(10) NOT NULL,
	CONSTRAINT PK_HoaDon PRIMARY KEY(SoHD),
	CONSTRAINT FK_HoaDon_NhanVien FOREIGN KEY(MaNV) REFERENCES NHANVIEN(MaNV),
	CONSTRAINT FK_HoaDon_KhachHang FOREIGN KEY(MaKH) REFERENCES KHACHHANG(MaKH),
	CONSTRAINT UNI_SoHD UNIQUE(SoHD)
)

CREATE TABLE CT_HOADON
(
	SoHD NCHAR(10) NOT NULL,
	MaTB NCHAR(10) NOT NULL,
	SoLuong INT NOT NULL,
	DonGia INT NOT NULL,
	ThanhTien INT NOT NULL,
	CONSTRAINT PK_CTHoaDon PRIMARY KEY(SoHD,MaTB),
	CONSTRAINT FK_CTHoaDon_ThietBi FOREIGN KEY(MaTB) REFERENCES THIETBI(MaTB),
	CONSTRAINT FK_CTHoaDon_HoaDon FOREIGN KEY(SoHD) REFERENCES HOADON(SoHD),
	CONSTRAINT CHK_SoLuong_CTHD check(SoLuong>=0)	
)

CREATE TABLE PHIEUNHAP
(
	SoPN NCHAR(10) NOT NULL,
	NgayLap_PN DATE NOT NULL,
	ThueXuat NCHAR(20),
	TongGiaTri INT NOT NULL,
	MaNV NCHAR(10) NOT NULL,
	MaNCC NCHAR(10) NOT NULL,
	CONSTRAINT PK_PhieuNhap PRIMARY KEY(SoPN),
	CONSTRAINT FK_PhieuNhap_NhanVien FOREIGN KEY(MaNV) REFERENCES NHANVIEN(MaNV),
	CONSTRAINT FK_PhieuNhap_NhaCungCap FOREIGN KEY(MaNCC) REFERENCES NHACUNGCAP(MaNCC),
	CONSTRAINT UNI_SoPN UNIQUE(SoPN)	
)

CREATE TABLE CT_PHIEUNHAP
(
	SoPN NCHAR(10) NOT NULL,
	MaTB NCHAR(10) NOT NULL,
	SoLuong INT NOT NULL,
	DonGia INT NOT NULL,
	ThanhTien INT NOT NULL,
	CONSTRAINT PK_CTPhieuNhap PRIMARY KEY(SoPN,MaTB),
	CONSTRAINT FK_CTPhieuNhap_ThietBi FOREIGN KEY(MaTB) REFERENCES THIETBI(MaTB),
	CONSTRAINT FK_CTPhieuNhap_PhieuNhap FOREIGN KEY(SoPN) REFERENCES PhieuNhap(SoPN),
	CONSTRAINT CHK_SoLuong_CTPN check(SoLuong>=0)
)

CREATE TABLE PHIEUCHI
(
	SoPC NCHAR(10) NOT NULL,
	NgayLap_PC DATE NOT NULL,
	LyDoChi NVARCHAR(50),
	SoTienChi INT NOT NULL,
	SoPN NCHAR(10) NOT NULL,
	CONSTRAINT PK_PhieuChi PRIMARY KEY(SoPC),
	CONSTRAINT FK_PhieuChi_PhieuNhap FOREIGN KEY(SoPN) REFERENCES PHIEUNHAP(SoPN),
	CONSTRAINT UNI_SoPC UNIQUE(SoPC),
	CONSTRAINT CHK_SoTienChi check(SoTienChi>=0)
)

CREATE TABLE CB_THANHLY
(
	MaThanhLy NCHAR(10) NOT NULL,
	NgayThanhLy DATE NOT NULL,
	LyDoThanhLy NVARCHAR(50),
	HinhThucThanhLy NVARCHAR(50) NOT NULL,
	GhiChu NVARCHAR(50),
	CONSTRAINT PK_CBThanhLy PRIMARY KEY(MaThanhLy),
	CONSTRAINT UNI_MaThanhLy UNIQUE(MaThanhLy)
)

CREATE TABLE CT_THANHLY
(
	MaThanhLy NCHAR(10) NOT NULL,
	MaTB NCHAR(10) NOT NULL,
	SoLuong INT NOT NULL,
	DonGia INT NOT NULL,
	ThanhTien INT NOT NULL,
	CONSTRAINT PK_CTThanhLy PRIMARY KEY(MaThanHLy,MaTB),
	CONSTRAINT FK_CTThanhLy_ThietBi FOREIGN KEY(MaTB) REFERENCES THIETBI(MaTB),
	CONSTRAINT FK_CTThanhLy_ThanhLy FOREIGN KEY(MaThanhLy) REFERENCES CB_THANHLY(MaThanhLy),
	CONSTRAINT CHK_SoLuong_ThanhLy check(SoLuong>=0),
	CONSTRAINT CHK_DonGia_ThanhLy check(DonGia>=0)
)

INSERT INTO CHUNGLOAI(MaCL,TenCL,DienGiai)
VALUES('CL001',N'Sách',N'Sách về các lĩnh vực Khoa Học, Văn Học'),
('CL002',N'Vật Dụng',N'Đồ chơi, Vật Dụng Văn Phòng,Vật Dụng Khác')

INSERT INTO NHOMLOAI(MaNL,TenNL,DienGiai,MaCL)
VALUES('NLS01',N'Sách Tin Học',N'Sách về các lĩnh vực Tin Học','CL001'),
		('NLS02',N'Sách Hóa Học',N'Sách về các lĩnh vực Hoa  Học','CL001'),
		('NLV03',N'Bút',N'Các loại bút','CL002'),
		('NLV04',N'giấy Note',N'Giấy Note các loại','CL002')

INSERT INTO THELOAI(MaTL,TenTL,MaNL,DienGiai)
VALUES('TLS01',N'Sách Tin Học văn phòng ','NLS01',N'Sách Tin Học Văn Phòng'),
		('TLS02',N'Sách PhotoShop  ','NLS01',N'Sách Kĩ thuật photoShop '),
		('TLS03',N'Sách Hóa Học Hữu Cơ ','NLS02',N'Sách Hóc học về hữu cơ '),
		('TLS04',N'Sách Hóa Học vô cơ','NLS02',N'Sách Hóa học về  vô cơ '),
		('TLB01',N'Bút Chì Kim','NLV03',N'Bút chì có ruột nhỏ'),
		('TLN01',N'Giấy Note ','NLV04',N'Giấy nhớ')

INSERT INTO NSX(MaNSX,TenNSX,DiaChi,SDT)
VALUES('NSX0000001',N'Nhà xuất bản Kim Đồng',N'55 Quang Trung, Hai Bà Trưng,Hà Nội','02439434730'),
('NSX0000002',N'Nhà xuất bản Trẻ',N'161B Lý Chính Thắng, Phường 7, Quận 3, Thành phố Hồ Chí Minh','02839316289'),
('NSX00000O3',N'Nhà xuất bản Tổng hợp thành phố Hồ Chí Minh',N' 62 Nguyễn Thị Minh Khai,Đa Kao, Quận 1, TP.HCM','02838225340'),
('NSX0000004',N'Nhà xuất bản giáo dục',N'81 Trần Hưng Đạo, Hà Nội','02438220801'),
('NSX0000005',N'Công Ty CP Tập Đoàn Thiên Long - Thien Long Group',N' Block 6-8-10-12 Road No. 3 Tan Tao IP, Bình Tân','02837505555')

INSERT INTO NHACUNGCAP(MaNCC,TenNCC,DiaChi,SDT)
VALUES('NCC0000001',N'Công Ty CP Tập Đoàn Thiên Long - Thien Long Group',N'Block 6-8-10-12 Road No. 3 Tan Tao IP, Bình Tân','02837505555'),
('NCC0000002',N'CÔNG TY TNHH SÁCH & TRUYỀN THÔNG VIỆT NAM',' 5 Đội Nhân, Vĩnh Phú, Hoàn Kiếm, Hà Nội','0462580800'),
('NCC0000003',N'CCông ty cổ phần Văn Hóa Đông A',N'113 Phố Đông Các, Chợ Dừa, Đống Đa, Hà Nội','0912215222'),
('NCC0000004',N'Công Ty Cổ Phần Văn Hóa Văn Lang',N'06 Nguyễn Trung Trực, P.5, Q. Bình Thạnh, TP.HCM','02838233022')

INSERT INTO KHACHHANG(MaKH,TenKH,MST,DiaChi,GioiTinh,SDT)
VALUES('KH00000001',N'Nguyễn Thế Anh','TH0001',N'40 Nguyễn Quý Anh, Quận Tân Phú,TP.HCM','Nam','0386136520'),
		('KH00000002',N'Nguyễn Hoàng Gia','TH0015',N'255 Tân Quỳ Tân Quý, Quận Tân Phú,TP.HCM','Nam','0386606352'),
		('KH00000011',N'Nguyễn Thị Hoa','TH0004',N'99 Đường Số 10, Quận Bình Tân,TP.HCM','Nữ','0913456776'),
		('KH00000021',N'Đoàn Phước Tân','TH0005',N'72 Tân Sơn Nhì, Quận Tân Phú,TP.HCM','Nam','0386677568'),
		('KH00000015',N'Cô Yến Vy','TH0022',N'56b Dương Đức Hiền, Quận Tân Phú, TP.HCM','Nữ','0913613652')

INSERT INTO NHANVIEN(MaNV,TenNV,ChucVu,DiaChi,GioiTinh,SDT)
VALUES('NV00000001',N'Nguyễn Thị Kim Tuyến',N'Thu Ngân',N'40 Nguyễn Quý Anh, Quận Tân Phú,TP.HCM','Nữ','0381621615'),
		('NV00000002',N'Đinh Thành Tín',N'Nhân Viên Tứ Vấn',N'77 Nguyễn CCuwr Đám, Quận Tân Phú,TP.HCM','Nam','0971621615'),
		('NV00000005',N'Đặng Xuân Dương',N'Kế Toán',N'479 Tan Quỳ Tân Quý, Quận Tân Phú,TP.HCM','Nam','038696884'),
		('NV00000008',N'Lê Quốc Khang',N'Nhân Viên Kho',N'499 Tân Kỳ Tân Quý, Quận Tân Phú,TP.HCM','Nam','0384480849'),
		('NV00000003',N'Nguyễn Thị Hồng Ngọc',N'Thu Ngân',N'77 Nguyễn Quý Anh, Quận Tân Phú,TP.HCM','Nữ','0381623615')

INSERT INTO KHO(MaKho,TenKho )
VALUES('K000000001',N'Kho A'),
('K000000002',N'Kho B')

SET DATEFORMAT DMY

INSERT INTO THIETBI(MaTB,TenTB,DVT,DVT_Max,DonGia,GiaNhap,SoLuongTon,NgayCapNhat,MaTL,MaNSX,MaKho)
VALUES('TB001',N'Sách Tin Học văn phòng cơ bản ',N'Quyển',N'Thùng','32000','20000','78','20/10/2019','TLS01','NSX00000O3','K000000001'),
('TBS02',N'Tìm hiểu về Các Nguyên Tố Nhóm V ',N'Quyển',N'Thùng','40000','25000','25','20/09/2019','TLS04','NSX0000004','K000000001'),
('TBS03',N'Phương pháp giải bài tập về pettit ',N'Quyển',N'Thùng','50000','40000','47','10/08/2019','TLS03','NSX0000004','K000000001'),
('TBS04',N'Photoshhop nâng cao ',N'Quyển',N'Thùng','100000','89000','38','01/08/2019','TLS02','NSX0000002','K000000001'),
('TBB01',N'Bút Chì Kim 5b(Thiên Long) ',N'cây',N'hộp','20000','15000','100','29/09/2019','TLB01','NSX0000005','K000000002'),
('TBB02',N'Bút Chì Kim 3b(Thiên Long) ',N'cây',N'hộp','10000','5000','100','15/09/2019','TLB01','NSX0000005','K000000002'),
('TBN01',N'Note vàng ',N'xấp',N'hộp','27000','20000','100','01/07/2019','TLN01','NSX0000005','K000000002')

INSERT INTO PHIEUNHAP(SoPN,NgayLap_PN,ThueXuat,TongGiaTri,MaNV,MaNCC)
VALUES('PN00000001','16/02/2019','200000','1800000','NV00000005','NCC0000002'),
('PN00000011','25/02/2019','300000','2700000','NV00000005','NCC0000003'),
('PN00000018','25/02/2019','100000','900000','NV00000005','NCC0000004')

INSERT INTO CT_PHIEUNHAP(SoPN,MaTB,SoLuong,DonGia,ThanhTien)
VALUES('PN00000001','TB001','100000','20000','1800000'),
('PN00000011','TBB01','200','15000','2700000'),
('PN00000018','TBN01','45','20000','900000')

INSERT INTO PHIEUCHI(SoPC,NgayLap_PC,LyDoChi,SoTienChi,SoPN)
VALUES('PC00000003','13/11/2019',N'mua thêm sách','1800000','PN00000001'),
('PC00000007','01/02/2019',N'mua kệ đựng sách','900000','PN00000018'),
('PC00000012','15/09/2019',N'mua thêm đồ chơi','2700000','PN00000011')

INSERT INTO HOADON(SoHD,NgayLap_HD,VAT,TongGiaTri,MaNV,MaKH)
VALUES('HD0000001','10/09/2019','20000','200000','NV00000001','KH00000002'),
('HD0000005','30/09/2019','30000','300000','NV00000003','KH00000011'),
('HD0000008','25/10/2019','40000','400000','NV00000001','KH00000015'),
('HD0000003','28/02/2019','50000','500000','NV00000001','KH00000021'),
('HD0000011','30/11/2019','90000','900000','NV00000003','KH00000001')

INSERT INTO CT_HOADON(MaTB,SoHD,DonGia,SoLuong,ThanhTien)
VALUES('TBS03','HD0000005','50000','6','330000'),
('TBB02','HD0000003','10000','50','550000'),
('TBS02','HD0000008','40000','10','440000')

INSERT INTO CB_THANHLY(MaThanhLy,NgayThanhLy,LyDoThanhLy,HinhThucThanhLy,GhiChu)
VALUES('TL00000001','20/10/2019',N'In hỏng',N'Trả về cho Nhà cung cấp',N'Đổi lô hàng mới'),
('TL00000003','26/10/2019',N'Hỏng Ngòi',N'Trả về cho Nhà cung cấp',N'Đổi lô hàng mới'),
('TL00000004','24/10/2019',N'Lộn hàng',N'Trả về cho Nhà cung cấp',N'Đổi hàng đúng')

INSERT INTO CT_THANHLY(MaThanhLy,MaTB,SoLuong,DonGia,ThanhTien)
VALUES('TL00000001','TBS03','20','40000','800000'),
('TL00000003','TBB02','50','5000','250000'),
('TL00000004','TBB01','100','15000','1500000')

update NSX set TenNSX = N'Nhà xuất bản ', DiaChi = N'161B Lý Chính Thắng, Phường 5, Quận 3, Thành phố Hồ Chí Minh', SDT = '02839316288' where MaNSX = 'NSX0000002'

('NSX0000002',N'Nhà xuất bản Trẻ',N'161B Lý Chính Thắng, Phường 7, Quận 3, Thành phố Hồ Chí Minh','02839316289'),






