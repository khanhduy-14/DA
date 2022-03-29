set serveroutput on;
--Tạo schema và phân quyền
--Tạo database quản lý đào tạo sát hạch và cấp giấy phép lái xe.
alter session set "_ORACLE_SCRIPT" = true;
create user quanlydtshgplx identified by 1;
GRANT ALL PRIVILEGES to quanlydtshgplx;

--Tạo bảng
Create Table Tinh
(
MaTinh number Constraint PK_Tinh_MaTinh Primary Key,
TenTinh varchar2(100) not null
);

Create Table DanToc
(
MaDanToc number Constraint PK_DanToc_MaDanToc Primary Key,
TenDanToc varchar2(100) not null
);

Create Table TonGiao
(
MaTonGiao number Constraint PK_TonGiao_MaTonGiao Primary Key,
TenTonGiao varchar2(100) not null
);

Create Table LyLich
(
SoLyLich char(10) Constraint PK_LyLich_SoLyLich Primary Key,
HoLot varchar2(50) not null,
Ten varchar2(50) not null,
NgaySinh date, 
GioiTinh varchar2(15) Constraint LyLich_GioiTinh_Check Check(GioiTinh in (N'Nam', N'Nữ', N'Khác')),
CMND varchar2(15)  Constraint LyLich_CMND_Unique Unique,
DiaChiThuongTru varchar2(200),
SoDienThoai varchar2(15) Constraint LyLich_SDT_Unique Unique,
QuocTich varchar2(50) not null,
MaTinh number Constraint FK_LyLich_MaTinh  references Tinh(MaTinh),
MaDanToc number Constraint FK_LyLich_MaDanToc  references DanToc(MaDanToc),
MaTonGiao number Constraint FK_LyLich_MaTonGiao references TonGiao(MaTonGiao)
);

Create Table CoSoDaoTao
(
MaCSDT char(5) Constraint PK_LyLich_MaCSDT Primary Key,
TenCSDT varchar2(70) not null
);

Create Table HangGPLX
(
MaHangGPLX char(2) Constraint PK_HangGPLX_MaHangGPLX Primary Key,
TenHangGPLX varchar2(70) not null,
LoaiXe varchar2(250) not null,
DiemLTToiDa number,
DiemTHToiDa number,
DiemLTToiThieu number ,
DiemTHToiThieu number ,
DoTuoiToiThieu number,
ThoiHan_Nam number,
Constraint CK_HangGPLX_DiemTHToiThieu Check(DiemTHToiThieu<DiemTHToiDa),
Constraint CK_HangGPLX_DiemLTToiThieu Check(DiemLTToiThieu<DiemLTToiDa)
);

Create Table GiayPhepLaiXe
(
SoLyLich char(10) Constraint FK_GiayPhepLaiXe_SoLyLich references LyLich(SoLyLich),
MaHangGPLX char(2)Constraint FK_GiayPhepLaiXe_MaHangGPLX  references HangGPLX(MaHangGPLX),
Serial char(30) not null Constraint GiayPhepLaiXe_Serial_Unique Unique,
NgayCap Date,
MaCSDT char(5) Constraint FK_GiayPhepLaiXe_MaCSDT references CoSoDaoTao(MaCSDT),
Constraint PK_GiayPhepLaiXe Primary Key(SoLyLich,MaHangGPLX)
);

Create Table KhoaDaoTao
(
MaKhoa char(10) Constraint PK_KhoaDaoTao_MaKhoa Primary Key,
TenKhoa varchar2(70) not null,
MaHangGPLX char(2)Constraint FK_KhoaDaoTao_MaHangGPLX references HangGPLX(MaHangGPLX),
MaCSDT char(5) Constraint FK_KhoaDaoTao_MaCSDT references CoSoDaoTao(MaCSDT)
);

Create Table DotSatHach
(
MaDotSatHach char(10) Constraint PK_DotSatHach_MaDotSatHach Primary Key,
TenDotSatHach varchar2(150) not null,
DiaDiemSatHach varchar2(200),
NgaySatHach date,
SoLuongToiDa number not null,
MaKhoa char(10) Constraint FK_DotSatHach_MaKhoa  references KhoaDaoTao(MaKhoa)
);

Create Table CanBo
(
MaCanBo char(5) Constraint PK_CanBo_MaCanBo Primary Key,
HoTenCanBo varchar2(100) not null,
SoDienThoai varchar2(15) Constraint CanBo_SoDienThoai_Unique Unique
);

Create Table TheoDoi
(
MaDotSatHach char(10) Constraint FK_TheoDoi_MaDSH  references DotSatHach(MaDotSatHach),
MaCanBo char(5) Constraint FK_TheoDoi_MaCanBo references CanBo(MaCanBo),
DiemDanhGia Integer not null Constraint CK_TheoDoi_DiemDanhGia Check(DiemDanhGia<=10 and DiemDanhGia>=0),
LyDo varchar2(200),
Constraint PK_TheoDoi Primary key(MaDotSatHach, MaCanBo)
);

Create Table HoSoDangKy
(
MaHoSoDangKy number Constraint PK_HoSoDangKy_MaHoSoDangKy Primary Key,
NgayDangKy date default sysdate,
XetDuyet varchar2(20) Constraint CK_HoDangDangKy_XetDuyet Check(XetDuyet in(N'Duyệt',N'Từ chối')),
LyDo varchar2(200),
SoLyLich char(10) Constraint FK_HoSoDangKy_SoLyLich references LyLich(SoLyLich),
MaDotSatHach char(10) Constraint FK_HoSoDangKy_MaDSH  references DotSatHach(MaDotSatHach),
KhoaDaoTao char(10) Constraint FK_HoSoDangKy_KhoaDaoTao references KhoaDaoTao(MaKhoa)
);

Create Table HoSoDuThi
(
MaHoSoDangKy number Constraint FK_HoSoDuThi_MaHoSoDangKy  references HoSoDangKy(MaHoSoDangKy),
LanThi number not null,
DiemLyThuyet number,
DiemThucHanh number,
KetQua varchar2(20) Constraint CK_HoSoDuThi_KetQua Check(KetQua in (N'Đậu',N'Rớt')),
Constraint PK_HoSoDuThi Primary Key(MaHoSoDangKy,LanThi)
);

--Dữ liệu mẫu
--Bảng tỉnh
Insert Into Tinh(MaTinh,TenTinh) values(1,N'TP. Hồ Chí Minh');
Insert Into Tinh(MaTinh,TenTinh) values(2,N'Bình Dương');
Insert Into Tinh(MaTinh,TenTinh) values(3,N'Bình Phước');
Insert Into Tinh(MaTinh,TenTinh) values(4,N'Đồng Nai');
Insert Into Tinh(MaTinh,TenTinh) values(5,N'Tây Ninh');

--Bảng dân tọc
Insert Into DanToc(MaDanToc,TenDanToc) values(1,N'Kinh');
Insert Into DanToc(MaDanToc,TenDanToc) values(2,N'Mường');
Insert Into DanToc(MaDanToc,TenDanToc) values(3,N'Tày');
Insert Into DanToc(MaDanToc,TenDanToc) values(4,N'Nùng');
Insert Into DanToc(MaDanToc,TenDanToc) values(5,N'Chăm');

--Bảng Tôn giáo
Insert Into TonGiao(MaTonGiao,TenTonGiao) values(1,N'Công Giáo');
Insert Into TonGiao(MaTonGiao,TenTonGiao) values(2,N'Phật Giáo');
Insert Into TonGiao(MaTonGiao,TenTonGiao) values(3,N'Tin Lành');
Insert Into TonGiao(MaTonGiao,TenTonGiao) values(4,N'Cao đài');

--Bảng lý lịch

Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('1101',N'Nguyễn Văn',N'Bình','12/JUN/1990',N'Nam','213456789',N'Quận 7','0935123458',N'Việt Nam',1,1,null);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('1102',N'Nguyễn Hiếu',N'Trung','6/MAY/2000',N'Nam','217456789',N'Quận 9','0935145658',N'Việt Nam',1,1,null);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('1211',N'Nguyễn Trần Phương',N'Thảo','15/APR/1998',N'Nữ','213456787',N'Gò Vấp','0933123458',N'Việt Nam',1,2,1);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('1331',N'Võ',N'Thảo','11/NOV/2002',N'Nam','211116789',N'Quận 1','0935123777',N'Việt Nam',1,3,3);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('1431',N'Lê Thị',N'Thảo','9/OCT/1992',N'Nữ','273456789',N'Quận 5','0825123888',N'Việt Nam',1,4,3);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('2101',N'Nguyễn Thị',N'Hạnh','12/DEC/2003',N'Nữ','215686789',N'Phú Giáo','0885123458',N'Việt Nam',2,1,null);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('2102',N'Nguyễn Hiếu',N'Thành','5/JAN/1995',N'Nam','117456789',N'Thuận An','0935144458',N'Việt Nam',2,1,null);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('2211',N'Lê Văn',N'Sự','1/JAN/2001',N'Nam','233456787',N'Dầu Tiếng','0833123477',N'Việt Nam',2,2,1);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('2331',N'Lê Thị Thúy',N'Vân','12/DEC/2002',N'Nữ','211126789',N'Thuận An','0935122877',N'Việt Nam',2,3,3);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('2531',N'Lê Thị Tường',N'Vy','9/OCT/1998',N'Nữ','2735556789',N'Phú Giáo','0825123778',N'Việt Nam',2,5,3);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('3101',N'Nguyễn Đỗ Thành',N'Nam','11/MAR/1997',N'Nam','312686789',N'Lộc Ninh','0885133458',N'Việt Nam',3,1,null);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('3221',N'Đào Kim',N'Oanh','1/NOV/2001',N'Nữ','12745559',N'Chơn Thành','098652314',N'Việt Nam',3,2,2);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('3311',N'Nguyễn Thị Mỹ',N'Trâm','1/JUL/2001',N'Nữ','344556787',N'Đồng Phú','0833223477',N'Việt Nam',3,3,1);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('3431',N'Võ Khắc',N'Vĩ','7/JUL/2001',N'Nam','211125789',N'Đồng Phú','0835122877',N'Việt Nam',3,4,3);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('3531',N'Nguyễn Tường',N'Vy','13/OCT/1996',N'Nữ','27342356789',N'Lộc Ninh','0825199778',N'Việt Nam',3,5,3);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('4101',N'Kim',N'Nhã','14/MAR/1997',N'Nam','344686789',N'Long Khánh','0833343458',N'Việt Nam',4,1,null);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('4221',N'Nguyễn Thị',N'Phúc','1/JUL/2003',N'Nữ','182745559',N'Long Thành','097552314',N'Việt Nam',4,2,2);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('4301',N'Đỗ Mỹ',N'Tiên','1/APR/2001',N'Nữ','399556787',N'Long Khánh','0833221277',N'Việt Nam',4,3,null);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('5411',N'Võ Thành',N'Nhơn','7/JUL/2002',N'Nam','2234125789',N'Bến Cầu','0835125677',N'Việt Nam',5,4,1);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('5511',N'Nguyễn Thành',N'Nhân','13/APR/2000',N'Nam','273421989',N'Gò Dầu','0875399778',N'Việt Nam',5,5,1);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('0001',N'King',N'Marthin','15/FEB/1998',N'Nam','777893',N'Paris','515.235.235',N'Pháp',null,null,null);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('0002',N'Author',N'Thon','5/MAY/2000',N'Nam','213123',N'LonDon','213.589.367',N'Anh',null,null,null);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('0003',N'Vladi',N'Edin','5/MAY/2015',N'Nam','1235556',N'LonDon','213.589.444',N'Anh',null,null,null);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('5512',N'Nguyễn Thiện',N'Nhân','13/DEC/2002',N'Nam','273421149',N'Gò Dầu','088745437',N'Việt Nam',5,5,1);
Insert Into LyLich(SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,QuocTich,MaTinh,MaDanToc,MaTonGiao)
values ('0004',N'Cris',N'Abimael','3/NOV/1999',N'Nam','1232344',N'Roma',null,N'Ý',5,1,1);

--Dữ liệu bảng cơ sở đào tạo
Insert into CoSoDaoTao(MaCSDT,TenCSDT) values('1','Trung tâm dạy nghề và đào tạo lái xe - Trường ĐHCSND');
Insert into CoSoDaoTao(MaCSDT,TenCSDT) values('2','Trường Cao đẳng GTVT TPHCM');
Insert into CoSoDaoTao(MaCSDT,TenCSDT) values('3','Trường Trung cấp nghề số 7');
Insert into CoSoDaoTao(MaCSDT,TenCSDT) values('4','Trường Trung cấp nghề số 6');

--Dữ liệu bảng hạng GPLX
Insert into HangGPLX(MaHangGPLX,TenHangGPLX,LoaiXe,DiemLTToiDa,DiemTHToiDa,DiemLTToiThieu,DiemTHToiThieu,DoTuoiToiThieu,ThoiHan_Nam)
values ('A1','Bằng lái xe hạng A1','Xe mô tô dung tích xy lanh từ 50 cm3 đến dưới 175 cm3, xe mô tô ba bánh dành cho người khuyết tật',25,100,21,80,18,null);
Insert into HangGPLX(MaHangGPLX,TenHangGPLX,LoaiXe,DiemLTToiDa,DiemTHToiDa,DiemLTToiThieu,DiemTHToiThieu,DoTuoiToiThieu,ThoiHan_Nam)
values ('A2','Bằng lái xe hạng A2','Xe mô tô hai bánh có dung tích xi-lanh từ 175 cm3 trở lên và các loại xe quy định cho giấy phép lái xe hạng A1',25,100,23,80,18,null);
Insert into HangGPLX(MaHangGPLX,TenHangGPLX,LoaiXe,DiemLTToiDa,DiemTHToiDa,DiemLTToiThieu,DiemTHToiThieu,DoTuoiToiThieu,ThoiHan_Nam)
values ('B2','Bằng lái xe hạng B2','Ô tô chuyên dùng có trọng tải thiết kế dưới 3.500 kg; các loại xe quy định cho giấy phép lái xe hạng B1',30,100,26,80,18,10);
Insert into HangGPLX(MaHangGPLX,TenHangGPLX,LoaiXe,DiemLTToiDa,DiemTHToiDa,DiemLTToiThieu,DiemTHToiThieu,DoTuoiToiThieu,ThoiHan_Nam)
values ('C','Bằng lái xe hạng C','Ô tô tải, kể cả ô tô tải chuyên dùng, ô tô chuyên dùng có trọng tải thiết kế từ 3.500 kg trở lên, các loại xe quy định cho giấy phép lái xe hạng B1, B2',30,100,28,80,21,5);
Insert into HangGPLX(MaHangGPLX,TenHangGPLX,LoaiXe,DiemLTToiDa,DiemTHToiDa,DiemLTToiThieu,DiemTHToiThieu,DoTuoiToiThieu,ThoiHan_Nam)
values ('D','Bằng lái xe hạng D','Ô tô chở người từ 10 đến 30 chỗ ngồi, kể cả chỗ ngồi cho người lái xe, các loại xe quy định cho giấy phép lái xe hạng B1, B2 và C',45,100,41,80,24,5);

--Dữ liệu giấy phép lái xe
Insert Into GiayPhepLaiXe(SoLyLich,MaHangGPLX,Serial,NgayCap,MaCSDT)
values ('1101','A2','11101A2','11/MAR/2015','1'); 
Insert Into GiayPhepLaiXe(SoLyLich,MaHangGPLX,Serial,NgayCap,MaCSDT)
values ('1101','B2','21101B2','3/MAR/2018','2'); 
Insert Into GiayPhepLaiXe(SoLyLich,MaHangGPLX,Serial,NgayCap,MaCSDT)
values ('3221','A1','33221A1','17/JUL/2020','3'); 
Insert Into GiayPhepLaiXe(SoLyLich,MaHangGPLX,Serial,NgayCap,MaCSDT)
values ('3531','A2','13531A2','12/APR/2019','1'); 
Insert Into GiayPhepLaiXe(SoLyLich,MaHangGPLX,Serial,NgayCap,MaCSDT)
values ('0001','A2','10001A2','9/NOV/2020','1'); 
Insert Into GiayPhepLaiXe(SoLyLich,MaHangGPLX,Serial,NgayCap,MaCSDT)
values ('4101','C','34101C','15/MAR/2020','3'); 
Insert Into GiayPhepLaiXe(SoLyLich,MaHangGPLX,Serial,NgayCap,MaCSDT)
values ('5411','A2','35411A2','30/DEC/2020','3'); 
Insert Into GiayPhepLaiXe(SoLyLich,MaHangGPLX,Serial,NgayCap,MaCSDT)
values ('2531','A1','12531A1','11/APR/2019','1'); 
Insert Into GiayPhepLaiXe(SoLyLich,MaHangGPLX,Serial,NgayCap,MaCSDT)
values ('2211','A2','22211A2','29/DEC/2019','2'); 
Insert Into GiayPhepLaiXe(SoLyLich,MaHangGPLX,Serial,NgayCap,MaCSDT)
values ('1431','A1','21431A1','7/JUL/2018','2'); 

--Dữ liệu bảng Khóa đào tạo
Insert Into KhoaDaoTao(MaKhoa,TenKhoa,MaHangGPLX,MaCSDT)
values ('1A11','Đào tạo sát hạch GPLX A1','A1',1);
Insert Into KhoaDaoTao(MaKhoa,TenKhoa,MaHangGPLX,MaCSDT)
values ('1A21','Đào tạo sát hạch GPLX A2','A2',1);
Insert Into KhoaDaoTao(MaKhoa,TenKhoa,MaHangGPLX,MaCSDT)
values ('1B21','Đào tạo sát hạch GPLX B2','B2',1);
Insert Into KhoaDaoTao(MaKhoa,TenKhoa,MaHangGPLX,MaCSDT)
values ('2A11','Đào tạo sát hạch GPLX A1','A1',2);
Insert Into KhoaDaoTao(MaKhoa,TenKhoa,MaHangGPLX,MaCSDT)
values ('3A11','Đào tạo sát hạch GPLX A1','A1',3);
Insert Into KhoaDaoTao(MaKhoa,TenKhoa,MaHangGPLX,MaCSDT)
values ('3B21','Đào tạo sát hạch GPLX B2','B2',3);
Insert Into KhoaDaoTao(MaKhoa,TenKhoa,MaHangGPLX,MaCSDT)
values ('3B22','Đào tạo sát hạch GPLX B2','B2',3);
Insert Into KhoaDaoTao(MaKhoa,TenKhoa,MaHangGPLX,MaCSDT)
values ('2C1','Đào tạo sát hạch GPLX C','C',2);
Insert Into KhoaDaoTao(MaKhoa,TenKhoa,MaHangGPLX,MaCSDT)
values ('2D1','Đào tạo sát hạch GPLX D','D',2);
Insert Into KhoaDaoTao(MaKhoa,TenKhoa,MaHangGPLX,MaCSDT)
values ('1D1','Đào tạo sát hạch GPLX D','D',1);
Insert Into KhoaDaoTao(MaKhoa,TenKhoa,MaHangGPLX,MaCSDT)
values ('3B23','Đào tạo sát hạch GPLX B2','B2',3);
--Dữ liệu bảng đợt sát hạch
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('1A111','Thi Sát Hạch GPLX A1','Quận 9','14/MAR/2020',10,'1A11');
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('1A112','Thi Sát Hạch GPLX A1','Quận 9','28/MAR/2020',10,'1A11');
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('1A113','Thi Sát Hạch GPLX A1','Quận 9','29/MAR/2020',10,'1A11');
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('2C11','Thi Sát Hạch GPLX C','Quận 2','1/JUL/2020',10,'2C1');
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('2C12','Thi Sát Hạch GPLX C','Quận 2','25/JUL/2020',10,'2C1');
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('2C13','Thi Sát Hạch GPLX C','Quận 2','1/SEP/2020',10,'2C1');
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('2D11','Thi Sát Hạch GPLX D','Quận 1','3/MAR/2020',10,'2D1');
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('3B211','Thi Sát Hạch GPLX B2','Quận 7','2/MAR/2019',15,'3B21');
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('3B212','Thi Sát Hạch GPLX B2','Quận 3','3/APR/2019',10,'3B21');
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('3B213','Thi Sát Hạch GPLX B2','Củ Chi','4/APR/2019',10,'3B21');
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('3B231','Thi Sát Hạch GPLX B2','Quận 1','2/FEB/2022',10,'3B23');
Insert Into DotSatHach(MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa)
values ('3B232','Thi Sát Hạch GPLX B2','Quận 1','2/APR/2022',0,'3B23');
--Dữ liệu bảng Cán bộ
Insert Into CanBo(MaCanBo,HoTenCanBo,SoDienThoai)
values('1','Nguyễn Sơn Tùng','058442369');
Insert Into CanBo(MaCanBo,HoTenCanBo,SoDienThoai)
values('2','Lê Phước Thịnh','033265746');
Insert Into CanBo(MaCanBo,HoTenCanBo,SoDienThoai)
values('3','Đỗ Tùng Sơn','058745698');
Insert Into CanBo(MaCanBo,HoTenCanBo,SoDienThoai)
values('4','Cao Thanh Bằng','088745437');
Insert Into CanBo(MaCanBo,HoTenCanBo,SoDienThoai)
values('5','Nguyễn Thanh Long','000745698');

--Dữ liệu bảng Theo Dõi
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('1A111','1',10,null);
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('1A112','2',10,null);
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('1A112','3',9,null);
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('1A113','3',8,null);
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('2C11','1',9,null);
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('2C11','3',10,null);
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('2C12','2',10,null);
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('2C13','1',7,null);
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('2D11','1',10,N'Tốt');
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('2D11','2',8,null);
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('2D11','3',6,null);
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('3B211','1',4,N'Công tác chuẩn bị chưa tốt');
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('3B212','1',3,N'Nhiều camera quan sát hư chưa được thay mới');
Insert Into TheoDoi(MaDotSatHach,MaCanBo,DiemDanhGia,LyDo)
values('3B212','4',10,null);

--Dữ liệu bảng Hồ sơ đăng ký
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(1,'1/JAN/2020',null,null,'4221','1A111','1A11');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(2,'1/FEB/2020',N'Duyệt',null,'1101','1A111','1A11');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(3,'5/FEB/2020',N'Duyệt',null,'1102','1A111','1A11');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(4,'7/JAN/2020',N'Duyệt',null,'5511','1A111','1A11');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(5,'3/FEB/2020',null,null,'5411','1A111','1A11');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(6,'17/FEB/2019',N'Duyệt',null,'3531','3B211','1A11');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(7,'15/FEB/2019',null,null,'3221','3B211','3B21');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(8,'17/JAN/2019',N'Duyệt',null,'0001','3B211','3B21');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(9,'5/FEB/2019',null,null,'1101','3B212','3B21');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(10,'17/FEB/2019',N'Duyệt',null,'1102','3B212','3B21');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(11,'17/AUG/2020',N'Duyệt',null,'0001','2C13','2C1');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(12,'1/JAN/2020',null,null,'2101','1A111','1A11');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(13,'17/AUG/2020',null,null,'0002','2D11','2D1');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(14,'17/AUG/2020',null,null,'3221','1A111','1A11');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(15,'17/AUG/2020',null,null,'4101','2C13','2C1');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(16,'20/NOV/2021',null,null,'4101','3B231','3B21');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(17,'17/AUG/2022',null,null,'4101','2C13','2C1');
--Dữ liệu bảng Hồ sơ dự thi

Insert Into HoSoDuThi(MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua)
values(1,1,10,null,N'Rớt');
Insert Into HoSoDuThi(MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua)
values(2,1,27,85,null);
Insert Into HoSoDuThi(MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua)
values(3,1,null,null,null);
Insert Into HoSoDuThi(MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua)
values(4,1,null,null,null);
Insert Into HoSoDuThi(MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua)
values(7,1,null,null,null);
Insert Into HoSoDuThi(MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua)
values(8,1,null,null,null);
Insert Into HoSoDuThi(MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua)
values(1,2,null,null,null);
Insert Into HoSoDuThi(MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua)
values(11,1,29,85,null);
Insert Into HoSoDuThi(MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua)
values(5,1,15,20,null);

--Tạo Index
--Tạo Index cho cột HoLot,Ten, DiaChiThuongTru  của bảng LyLich
Create Index index_LyLich_HoLot on LyLich(HoLot);
Create Index index_LyLich_Ten on LyLich(Ten);
Create Index index_LyLich_DiaChiThuongTru on LyLich(DiaChiThuongTru);

--Tạo Index cho cột HoTenCanBo trong bảng CanBo
Create Index index_CanBo_HoTenCanBo on CanBo(HoTenCanBo);

--UPDATE
--Câu lệnh cập nhật (Update) liên quan đến nghiệp vụ:
--Câu 1: Cập nhật lại thuộc tính Xét Duyệt là Từ chối và lý do là mã hạng giấy phép lái xe của khóa đào tạo không trùng 
--với mã hạng giấy phép lái xe của đợt sát hạch.

--Nối giữa bảng HoSoDangKy với các bảng DotSatHach và KhoaDaoTao để tạo ra 2 cột Hạng GPLX: 1 cột do DotSatHach chuẩn bị sát hạch và 1 cột do KhoaDaoTao đó đào tạo
--lưu vào 1 bảng tên temp_table xử lý nếu hạng giấy từ bảng đào tạo khác hạng giấy từ bảng sát hạch thì từ chối và nêu lý do.

Update (Select MaHoSoDangKy, XetDuyet,LyDo, A.MaHangGPLX as MaHangGPLX_DotSatHach, khoadaotao.mahanggplx as MaHangGPLX_KhoaDaoTao
From HoSoDangKy 
inner join 
(Select MaDotSatHach,MaHangGPLX from DotSatHach inner join KhoaDaoTao on DotSatHach.MaKhoa=KhoaDaoTao.MaKhoa) A on hosodangky.madotsathach=A.madotsathach
inner join KhoaDaoTao on khoadaotao.makhoa=hosodangky.khoadaotao) temp_table
Set temp_table.XetDuyet=N'Từ chối', temp_table.LyDo=N'Mã hạng GPLX của khóa đào tạo không hợp lệ với đợt sát hạch'
Where temp_table.MaHangGPLX_DotSatHach!=temp_table.MaHangGPLX_KhoaDaoTao;

select * from hosodangky

--Câu 2: Cập nhật tên các đợt sát hạch theo cú pháp: Tên đợt sát hạch + Mã khóa: [MaKhoa] thể hiện mã khóa mở cuộc thi đợt sát hạch đó
Update DotSatHach
Set TenDotSatHach=TenDotSatHach||' '||N'Mã khóa: '||MaKhoa;

select * from dotsathach

--Câu 3: Cập nhật tên các đợt sát hạch có mã khóa đào tạo tổ chức là '1A11' theo cú pháp Tên đợt sát hạch + Lần thứ [Lần thi khóa đó tổ chức] biết 
-- lần thi được sắp xếp theo ngày. Ví dụ do cùng 1 khóa đào tạo 1A11 tổ chức sát hạch, đợt sát hạch tổ chức trước thì là lần 1, tiếp theo lần 2,...

Update (Select DotSatHach.MaDotSatHach,TenDotSatHach,MaKhoa,rank_date  from 
DotSatHach
inner join (Select MaDotSatHach,rank() over(order by ngaysathach) as rank_date from DotSatHach Where MaKhoa='1A11') A 
on A.madotsathach=dotsathach.madotsathach) temp_table
Set TenDotSatHach=TenDotSatHach||' '||N'Lần thi: '||temp_table.rank_date;

select * from dotsathach
--Câu 4: Cập nhật hồ sơ đăng ký xét duyệt: Từ chối, Lý Do: Không đủ tuổi đối với các hồ sơ đăng ký nhưng không đủ tuổi dự thi theo hạng giấy phép lái xe đó quy định
--Tuổi được tính bằng đủ số tháng. Ví dụ sinh ngày 1/1/2001 thì sẽ được thi bằng lái xe A1(bằng A1 quy định 18 tuổi) vào ngày 1/1/2019

Update (Select MaHoSoDangKy,XetDuyet,LyDo, LyLich.SoLyLich, DotSatHach.MaDotSatHach,lylich.ngaysinh,hanggplx.dotuoitoithieu,dotsathach.ngaysathach
from HoSoDangKy
inner join LyLich on hosodangky.solylich=lylich.solylich
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join hanggplx on hanggplx.mahanggplx=khoadaotao.mahanggplx) temp_table
Set temp_table.xetduyet=N'Từ chối', temp_table.lydo=N'Không đủ tuổi'
Where add_months(NgaySinh,DoTuoiToiThieu*12)>NgaySatHach

select * from hosodangky
--Câu 5: Cập nhật hồ sơ đang ký bằng giấy phép lái xe hàng D với thông tin xét duyệt: Từ chối, Lý Do: Chưa đủ các bằng GPLX yêu cầu đối với những người dự thi
--chưa có bằng B2 và C theo quy định pháp luật yêu cầu.
Update  (Select MaHoSoDangKy,XetDuyet,LyDo, SoLyLich, DotSatHach.MaDotSatHach,MaHangGPLX
from HoSoDangKy
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa) temp_table
Set temp_table.XetDuyet=N'Từ chối', temp_table.LyDo=N'Chưa có bằng GPLX hạng B2 hoặc C chưa thể thi bằng D'
Where temp_table.MaHangGPLX='D' and not exists (select 1 from GiayPhepLaiXe where temp_table.SoLyLich=GiayPhepLaiXe.SoLyLich and MaHangGPLX not in ('B2','C'));

select * from hosodangky
--Câu 6: Cập nhật hồ sơ dự thi cho thí sinh thi trượt. Biết tùy vào mã hạng giấy phép lái xe mà có mức điểm đậu và trượt khác nhau
--Ví dụ hạng C phải thi 28/30 câu lý thuyết và 80/100 điểm thực hành mới được tính là đậu. Nếu thí sinh thi trượt thì cập nhất Kết qua: Rớt

Update (Select HoSoDangKy.MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua,DiemLTToiThieu,DiemTHToiThieu
From HoSoDuThi
inner Join HoSoDangKy on hosodangky.mahosodangky=hosoduthi.mahosodangky
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join hanggplx on hanggplx.mahanggplx=khoadaotao.mahanggplx)
Set KetQua=N'Rớt'
Where DiemLyThuyet<DiemLTToiThieu or DiemThucHanh<DiemTHToiThieu;

select * from hosoduthi
--Câu 7: Cập nhật thông tin bảng theo dõi đối với các đợt tổ chức thi được cán bộ đánh giá bằng 10 thì cập nhật lý do đánh giá: Cuộc thi diễn ra tốt đẹp, tổ chức tốt.
Update TheoDoi
Set LyDo=N'Cuộc thi diễn ra tốt đẹp, tổ chức tốt'
Where DiemDanhGia=10;

Select * from theodoi
--Câu 8:Cập nhật thông tin cho bảng hồ sơ đăng ký từ chối các hồ sơ đăng ký đăng ký thi bằng lái phép lái xe đã có và chưa hết hạn sử dụng tính đến ngày hiện tại.

Update (Select MaHoSoDangKy,XetDuyet,LyDo, LyLich.SoLyLich, DotSatHach.MaDotSatHach,thoihan_nam,hanggplx.mahanggplx
from HoSoDangKy
inner join LyLich on hosodangky.solylich=lylich.solylich
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join hanggplx on hanggplx.mahanggplx=khoadaotao.mahanggplx) temp_table
Set temp_table.xetduyet=N'Từ chối', temp_table.lydo=N'Đã có bằng GPLX hạng này và chưa hết hạn'
Where exists (select 1 from GiayPhepLaiXe where giaypheplaixe.solylich=temp_table.solylich 
and giaypheplaixe.mahanggplx=temp_table.mahanggplx and (add_months(giaypheplaixe.ngaycap,temp_table.thoihan_nam*12)>sysdate or temp_table.thoihan_nam is null))

select * from hosodangky

--Câu 9: Cập nhật lại điểm thi lý thuyết bằng điểm thi lý thuyết lần 1 đối với các thí sinh thi lại lần 2 trong cùng 1 đợt sát hạch, điểm thực hành và kết quả
-- bằng null trong hồ sơ dự thi.
 Update HoSoDuThi A
 Set DiemLyThuyet=(Select DiemLyThuyet from HoSoDuThi B Where B.MaHoSoDangKy=A.MaHoSoDangKy and B.LanThi=1)
 where LanThi=2;

select * from hosoduthi
--Câu 10: Cập nhật hồ sơ dự thi cho thí sinh thi đậu. Biết tùy vào mã hạng giấy phép lái xe mà có mức điểm đậu và trượt khác nhau
--Ví dụ hạng C phải thi 28/30 câu lý thuyết và 80/100 điểm thực hành mới được tính là đậu. Nếu thí sinh thi đậu thì cập nhất Kết qua: Đậu

Update (Select HoSoDangKy.MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua,DiemLTToiThieu,DiemTHToiThieu
From HoSoDuThi
inner Join HoSoDangKy on hosodangky.mahosodangky=hosoduthi.mahosodangky
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join hanggplx on hanggplx.mahanggplx=khoadaotao.mahanggplx)
Set KetQua=N'Đậu'
Where DiemLyThuyet>=DiemLTToiThieu or DiemThucHanh>=DiemTHToiThieu;

select * from hosoduthi
--DELETE
--Câu lệnh xóa (DELETE) liên quan đến nghiệp vụ
--Câu 1: Xóa cơ sở đào đạo có tên Trường Trung cấp nghề số 6

Delete from CosoDaoTao
where TenCSDT=N'Trường Trung cấp nghề số 6';

--Câu 2: Xóa các cán bộ coi thi có số điện thoại bắt đầu bằng 3 số 000
Delete from CanBo
where SoDienThoai like '000%';

--Câu 3: Xóa các khóa đạo tạo dạy giấy phép bằng D của cơ sở đào tạo 1
Delete from KhoaDaoTao
where MaCSDT=1 and MaHangGPLX='D';

--Câu 4: Xóa những số lý lịch của người thi có ngày sinh nằm trong năm 2015
Delete from LyLich
where ngaysinh between '1/JAN/2015' and '31/DEC/2015';

--Câu 5: Xóa bằng lái xe hạng B2 của người có số lý lịch 1101
Delete from giaypheplaixe
where solylich='1101' and mahanggplx='B2';

-- Câu 6: Xóa cuộc thi sát hạch có địa điểm sát hạch tại Củ Chi
Delete from dotsathach
where diadiemsathach=N'Củ Chi';

--Câu 7: Xóa lý lịch của người dự thi có số điện thoại trung với số điện thoại của cán bộ giám sát
Delete from lylich
where exists (Select 1 from canbo where canbo.sodienthoai=lylich.sodienthoai);

--Câu 8: Xóa nội dung chấm điểm đánh giá trong mục theo dõi của cán bộ giám sát Cao Thanh Bằng
Delete from TheoDoi
where MaCanBo =(Select MaCanBo from CanBo where HoTenCanBo=N'Cao Thanh Bằng');

--Câu 9: Xóa những hồ sơ lý lịch quốc tịch không phải là Việt Nam nhưng lại có Mã dân tộc trong bộ mã dân tộc Việt Nam 
--(Nếu không phải ngươi Việt Nam thì mã dân tộc để null)
Delete from LyLich
where lylich.quoctich!=N'Việt Nam' and lylich.madantoc is not null;

--Câu 10: Xóa hồ sơ dự thi có hồ sơ đăng ký bị xét duyệt là từ chối
Delete from hosoduthi
where exists (select 1 from hosodangky where hosodangky.mahosodangky=hosoduthi.mahosodangky and hosodangky.xetduyet=N'Từ chối');

--SELECT
--30 Câu lệnh SELECT liên quan đến nghiệp vụ theo đề tài
--Câu 1: Liệt kê những hồ sơ lý lịch của người dự thi 
--bao gồm các thông tin: SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai. Đánh giá xem người này ở hiện tại đủ thuổi thi bằng D hay không 
-- nếu không hiển thị ra số ngày.
select  SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,
case when add_months(NgaySinh,(Select hanggplx.dotuoitoithieu from hanggplx where mahanggplx='D')*12)>sysdate 
    then N'Còn thiếu '|| to_char(ceil(add_months(NgaySinh,(Select hanggplx.dotuoitoithieu from hanggplx where mahanggplx='D')*12)-sysdate))||' ngày'
else N'Đủ điều kiện'
end as DieuKienTuoiThi_Bang_D
from LyLich
order by Ten;

--Câu 2: Liệt kê ra thông tin những hồ sơ lý lịch chưa tham gia thi bằng lái hạng C mặc dù đã đủ tuổi (tính tới thời điểm hiện tại).
--Thông tin hiển thị gồm: SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai
select  SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai
from LyLich
where SoLyLich not in (Select SoLyLich from HoSoDangKy where MaHoSoDangKy not in (Select MaHoSoDangKy From HoSoDuThi))
and add_months(NgaySinh,(Select hanggplx.dotuoitoithieu from hanggplx where mahanggplx='C')*12)<sysdate
order by Ten,NgaySinh;

--Câu 3: : Liệt kê các đợt sát hạch có điểm trung bình được chấm bởi các cán bộ lớn hơn hoặc điểm trung bình chung của toàn bộ đợt sát hạch được chấm
--Thông tin hiểm thị bao gồm: MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa,DiemTrungBinhDanhGia

select DotSatHach.MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa,avg(theodoi.diemdanhgia) as DiemTrungBinhDanhGia
from dotsathach 
inner join theodoi on theodoi.madotsathach=dotsathach.madotsathach
Group By DotSatHach.MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,MaKhoa
Having avg(theodoi.diemdanhgia) >= (select avg(theodoi.diemdanhgia) from theodoi)
order by TenDotSatHach;

--Câu 4: Thống kê số lượng thí sinh còn lại của mỗi đợt sát hạch, số lượng thí sinh đã đăng ký tham gia chỉ tính những hô sơ được xét duyệt.
--Thông tin hiển thị bao gồm: MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,SoLuongConLai

select MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa,
(Select (SoLuongToiDa- count(SoLyLich))from HoSoDangKy where hosodangky.madotsathach=dotsathach.madotsathach and hosodangky.xetduyet=N'Duyệt' ) as SoLuongConLai
from dotsathach
order by TenDotSatHach;

--Câu 5: Liệt kê những thí sinh có hạng giấy phép lái xe từ khóa đào tạo khác với hạng giấy phép lái xe của đợt sát hạch đăng ký dự thi.
--thông tin hiển thị gồm: SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,MaHangGPLX_DotSatHach, MaHangGPLX_KhoaDaoTao

Select HoSoDangKy.SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai, A.MaHangGPLX as MaHangGPLX_DotSatHach, khoadaotao.mahanggplx as MaHangGPLX_KhoaDaoTao
From HoSoDangKy 
inner join 
(Select MaDotSatHach,MaHangGPLX from DotSatHach inner join KhoaDaoTao on DotSatHach.MaKhoa=KhoaDaoTao.MaKhoa) A on hosodangky.madotsathach=A.madotsathach
inner join KhoaDaoTao on khoadaotao.makhoa=hosodangky.khoadaotao 
inner join LyLich on lylich.solylich=HoSoDangKy.SoLyLich
where A.MaHangGPLX != khoadaotao.mahanggplx
order by ten,ngaysinh;

--Câu 6: Thống kê số lượng thí sinh đăng ký thi các hạng giấy phép lái xe mà cơ sở đào tạo có mã cơ sở đào tạo:1 đã tổ chức.
--Thông tin hiển thị bao gồm: MaHangGPLX,TenHangGPLX,SoLuongDangKy

Select KhoaDaoTao.MaHangGPLX,TenHangGPLX,count(mahosodangky) as SoLuongDangKy
From CoSoDaoTao
inner join KhoaDaoTao on khoadaotao.macsdt=cosodaotao.macsdt
left join dotsathach on dotsathach.makhoa=khoadaotao.makhoa
left join HangGPLX on hanggplx.mahanggplx=khoadaotao.mahanggplx
left join hosodangky on hosodangky.madotsathach=dotsathach.madotsathach
where CoSoDaoTao.MaCSDT='1'
Group by KhoaDaoTao.MaHangGPLX,TenHangGPLX
order by mahanggplx;

--Câu 7: Liệt kê hồ sơ lý lịch của những người đang sỡ hữu giấy phép lái xe và cho biết ngày hết hạn của những bằng lái đó.
--Thông tin hiển thị bao gồm: SoLyLich, HoTen,NgaySinh,GioiTinh,CMND,maHangGPLX,Serial,NgayCap,NgayHetHan

select LyLich.SoLyLich,HoLot||' '||Ten as HoTen,NgaySinh,GioiTinh,CMND,maHangGPLX,Serial,NgayCap, 
case
when  ((Select hanggplx.thoihan_nam from hanggplx where hanggplx.mahanggplx= giaypheplaixe.mahanggplx) is null) then N'Vĩnh viễn'
when ((Select hanggplx.thoihan_nam from hanggplx where hanggplx.mahanggplx= giaypheplaixe.mahanggplx) is not null)  then
N''||(add_months(NgayCap,(Select hanggplx.thoihan_nam from hanggplx where hanggplx.mahanggplx= giaypheplaixe.mahanggplx)*12))
end as NgayHetHan
from GiayPhepLaiXe inner join
LyLich on giaypheplaixe.solylich=lylich.solylich
order by holot||' '||ten,ngaysinh;

--Câu 8: Cho biết cán bộ được cử đi giám sát đợt sát hạch nhiều nhất
--Thông tin hiển thị gồm: MaCanBo,HoTenCanBo,SoDienThoai
select CanBo.MaCanBo,HoTenCanBo,SoDienThoai
from CanBo
inner join TheoDoi On canbo.macanbo=theodoi.macanbo
group by CanBo.MaCanBo,HoTenCanBo,SoDienThoai
having count(CanBo.MaCanBo) = (Select Max(Count(MaCanBo)) from theodoi group by macanbo);

--Câu 9: Cho biết cán bộ chấm điểm các đợt sát hạch có điểm chấm trung bình tất cả các đợt mà cán bộ đó giám sát
--lớn hơn điểm chấm trung bình các đợt sát hạch của ít nhất các cán bộ khác
--Thông tin hiển thị gồm: MaCanBo,HoTenCanBo,SoDienThoai,DiemChamTrungBinh

select CanBo.MaCanBo,HoTenCanBo,SoDienThoai,avg(theodoi.diemdanhgia)
from CanBo
inner join TheoDoi On canbo.macanbo=theodoi.macanbo
group by CanBo.MaCanBo,HoTenCanBo,SoDienThoai
having avg(theodoi.diemdanhgia) > (Select MIN(AVG(theodoi.diemdanhgia)) from theodoi group by macanbo);

--Câu 10: Liệt kê những thí sinh đăng ký thi bằng giấy phép lái xe hạng D nhưng chưa có bằng C hoặc B2 (theo luật quy định không thể học trực tiếp bằng lái D
--mà phải nâng lên từ bằng B2 hoặc C)
--Thông tin hiển thị gồm: SoLyLich, HoTen,NgaySinh,GioiTinh,CMND
select LyLich.SoLyLich,HoLot||' '||Ten as HoTen,NgaySinh,GioiTinh,CMND
from HoSoDangKy
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join LyLich on hosodangky.solylich=lylich.solylich
Where MaHangGPLX='D' and LyLich.SoLyLich not in (select GiayPhepLaiXe.SoLyLich from GiayPhepLaiXe where MaHangGPLX not in ('B2','C'))
order by HoLot||' '||Ten,ngaysinh;

--Câu 11: Cho biết những hạng giấy phép lái xe mà người thi có số lý lịch là '3531' đủ tuổi thi tính tới thời điểm hiện tại (Một năm được lấy là 365 ngày):
--Thông tin hiển thị bao gồm: MaHangGPLX,TenHangGPLX
select MaHangGPLX,TenHangGPLX
from HangGPLX
where hanggplx.dotuoitoithieu*365<= (select floor(sysdate-ngaysinh) from LyLich where SoLyLich='1102')

--Câu 12: Cho biết số lượng người theo từng tỉnh đã đăng ky dự thi.
--Thông tin hiển thị bao gồm: MaTinh,TenTinh,SoLuongNguoiDangKy
select tinh.matinh,tentinh,count(lylich.solylich) as SoLuongNguoiDangKiThiGPLC
from tinh
inner join lylich on tinh.matinh=lylich.matinh
inner join hosodangky on lylich.solylich=hosodangky.solylich
group by tinh.matinh,tentinh;

--Câu 13:  Cho biết cán bộ được cử đi giám sát đợt sát hạch ít nhất
--Thông tin hiển thị gồm: MaCanBo,HoTenCanBo,SoDienThoai

select CanBo.MaCanBo,HoTenCanBo,SoDienThoai
from CanBo
left join TheoDoi On canbo.macanbo=theodoi.macanbo
group by CanBo.MaCanBo,HoTenCanBo,SoDienThoai
having count(CanBo.MaCanBo) = (Select Min(Count(CanBo.MaCanBo)) from CanBo left join theodoi On canbo.macanbo=theodoi.macanbo group by CanBo.macanbo);

--Câu 14: Liệt kê ra những thí sinh họ Đào đã có giấy phép lái xe hạng A1
--Thông tin hiển thị gồm: SoLyLich, HoTen,NgaySinh,GioiTinh,CMND
select SoLyLich,HoLot||' '||Ten as HoTen,NgaySinh,GioiTinh,CMND
from LyLich 
where HoLot like N'Đào%'
and SoLyLich in (Select SoLyLich from GiayPhepLaiXe where MaHangGPLX='A1')
order by HoLot||' '||Ten,NgaySinh;

--Câu 15: Cho biết số người thi trượt lý thuyết ở các hạng giấy phép lái xe
-- Thông tin hiển thị bao gồm: Mã Hạn Giấy Phép Lái Xe, Tên Hạng Giấy Phép Lái Xe, Số Người Thi Trượt Lý Thuyết
Select hanggplx.mahanggplx,tenhanggplx,
sum(case when hosoduthi.diemlythuyet<(select hanggplx.diemlttoithieu from hanggplx where mahanggplx=khoadaotao.mahanggplx) then 1
else 0
end) as SoLuongThiTruotLyThuyet
from hosoduthi
inner join hosodangky on hosoduthi.mahosodangky=hosodangky.mahosodangky
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join hanggplx on hanggplx.mahanggplx=khoadaotao.mahanggplx
group by hanggplx.mahanggplx,tenhanggplx

--Câu 16: Cho biết số lượng nam, số lượng nữ đăng kí thi giấy phép lái xe.
Select count(case when gioitinh=N'Nam' then 1 end) as SoLuongNamDangKy,
count(case when gioitinh=N'Nữ' then 1 end) as SoLuongNuDangKy
from lylich
inner join hosodangky on lylich.solylich=hosodangky.solylich

--Câu 17: Cho phép người dùng nhập vào số lý lịch và mã hạng gplx mà họ muốn thi hiển thị ra các đợt sát hạch mà người đó đủ tuổi tham gia
--và đợt sát hạch đó chưa diễn ra.
--Thông tin hiển thị gồm: MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa

select DotSatHach.MaDotSatHach,TenDotSatHach,DiaDiemSatHach,NgaySatHach,SoLuongToiDa
from dotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
where NgaySatHach > sysdate
and ngaysathach > add_months((select  distinct ngaysinh from hosodangky inner join lylich on lylich.solylich=hosodangky.solylich
where hosodangky.solylich=&so_ly_lich),(select dotuoitoithieu  from hanggplx where mahanggplx='&ma_hang_gplx_thi')*12);

--Câu 18: Cho biết những thí sinh đã thi lại lần 2 trong cùng 1 đợt sát hạch
--Thông tin hiển thị bao gồm: Mã Đợt Sát Hạch,Mã hạng giấy phép lai, Họ tên,CMND ,Điểm lý thuyết, điểm thực hành

Select  DotSatHach.MaDotSatHach,MaHangGPLX, HoLot||' '||Ten as HoTen,CMND,DiemLyThuyet, DiemThucHanh
from HoSoDangKy
inner join LyLich on hosodangky.solylich=lylich.solylich
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join HoSoDuThi on hosodangky.mahosodangky=hosoduthi.mahosodangky
where lanthi=2
order by HoLot||' '||Ten,NgaySinh;

--Câu 19: Thống kê số lượng đăng ký dự thi giấy phép lái xe của từng tôn giáo
--Thông tin hiển thị bao gồm: Mã tôn giáo, tên tôn giáo, số lượng đăng ký giấy phép lái xe

Select Tongiao.MaTonGiao,TenTonGiao, count(lylich.SoLyLich) as SoLuongDangKyDuThiGPLX
from tongiao
left join lylich on lylich.matongiao=tongiao.matongiao
left join hosodangky on hosodangky.solylich=lylich.solylich
group by Tongiao.MaTonGiao,TenTonGiao

--Câu 20: Cho biết số lượng thí sinh nữ đã đăng ký các hạng giấy phép lái xe
-- Thông tin hiển thị bao gồm: mahanggplx,tenhanggplx,soluongthisinhnu
Select hanggplx.mahanggplx,tenhanggplx,
sum(case when gioitinh='Nữ' then 1 else 0 end) as soluongthisinhnu
From hanggplx 
left join khoadaotao on khoadaotao.mahanggplx=hanggplx.mahanggplx
left join hosodangky on khoadaotao.makhoa=hosodangky.khoadaotao
left join lylich on lylich.solylich=hosodangky.solylich
group by hanggplx.mahanggplx,tenhanggplx

--Câu 21: Cho biết những thí sinh đã đăng ký tham gia dự thi hạng giấy phép lái xe tuy nhiên những thí sinh này đã có giấy phép lái xe đó và chưa hết hạn
-- Thông tin hiển thị gồm:  SoLyLich, HoTen,NgaySinh,GioiTinh,CMND,MaHangGPLX as MaHangGPLXDangKyThi
Select  LyLich.SoLyLich, HoLot||' '||Ten as HoTen,NgaySinh,GioiTinh,CMND,khoadaotao.mahanggplx,tenhanggplx
from HoSoDangKy
inner join LyLich on hosodangky.solylich=lylich.solylich
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join hanggplx on hanggplx.mahanggplx=khoadaotao.mahanggplx
Where exists (select 1 from GiayPhepLaiXe where giaypheplaixe.solylich=lylich.solylich 
and giaypheplaixe.mahanggplx=khoadaotao.mahanggplx and (add_months(giaypheplaixe.ngaycap,hanggplx.thoihan_nam*12)>sysdate or hanggplx.thoihan_nam is null))

--Câu 22: Liệt kê những thí sinh đăng ký thi giấy phép lái xe nhưng không đủ tuổi (tính theo tháng)
--Thông tin hiển thị gồm: SoLyLich, HoTen,NgaySinh,GioiTinh,CMND,MaHangGPLX as MaHangGPLXDangKyThi

Select  LyLich.SoLyLich, HoLot||' '||Ten as HoTen,NgaySinh,GioiTinh,CMND,khoadaotao.mahanggplx
from HoSoDangKy
inner join LyLich on hosodangky.solylich=lylich.solylich
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join hanggplx on hanggplx.mahanggplx=khoadaotao.mahanggplx
Where add_months(NgaySinh,DoTuoiToiThieu*12)>NgaySatHach
order by HoLot||' '||Ten,NgaySinh;

--Câu 23: Nhập vào họ tên của người cần tra cứu vào cho biết những giấy phép lái xe mà người đó đang sở hữu.
--Thông tin hiển thị bao gồm: Mã hạng GPLX,serial, tên hạng GPLX, ngày cấp, ngày hết hạn
Select hanggplx.mahanggplx,tenhanggplx,serial,ngaycap,
(case when hanggplx.thoihan_nam is null then N'Vĩnh viễn'
else N''||(add_months(ngaycap,hanggplx.thoihan_nam*12)) end) as NgayHetHan
from giaypheplaixe inner join hanggplx on hanggplx.mahanggplx=giaypheplaixe.mahanggplx
inner join lylich on lylich.solylich=giaypheplaixe.solylich
where Upper(HoLot||' '||Ten)=Upper('&Ho_ten')

--Câu 24: Liệt kê hồ sơ lý lịch của những người đang sỡ hữu giấy phép lái xe và cho biết giấy phép lái xe đó đã hết hạn bao ngày
--Thông tin hiển thị bao gồm: SoLyLich, HoTen,NgaySinh,GioiTinh,CMND,maHangGPLX,Serial,NgayCap,NgayHetHan

select LyLich.SoLyLich,HoLot||' '||Ten as HoTen,NgaySinh,GioiTinh,CMND,maHangGPLX,Serial,NgayCap, 
case
when  ((Select hanggplx.thoihan_nam from hanggplx where hanggplx.mahanggplx= giaypheplaixe.mahanggplx) is null) then N'Chua Het Han'
when ((add_months(giaypheplaixe.ngaycap,(Select hanggplx.thoihan_nam from hanggplx where hanggplx.mahanggplx= giaypheplaixe.mahanggplx )*12)) > sysdate)  then N'Chua Het Han'
else N'Đã hết hạn '|| to_char(ceil(sysdate-add_months(giaypheplaixe.ngaycap,(Select hanggplx.thoihan_nam from hanggplx where hanggplx.mahanggplx= giaypheplaixe.mahanggplx )*12)))||' ngày'
end as NgayHetHan
from GiayPhepLaiXe inner join
LyLich on giaypheplaixe.solylich=lylich.solylich
order by holot||' '||ten,ngaysinh;

--Câu 25: Biết thời gian bảo lãnh kết quả học tập của thí sinh là 1 năm tính từ ngày kết thúc khóa đào tạo (là ngày đợt sát hạch cuối cùng của khóa đào tạo kết thúc) 
-- tức là trong vòng 1 năm thí sinh có thể thi bằng giấy phép lái xe mà thí sinh đó tham gia đào tạo còn nếu quá 1 năm thí sinh sẽ phải học lại
--hãy liệt kê các khóa đào tạo và cho biết khi nào thí sinh tham gia khóa đạo tạo đó sẽ không được dự thi bằng lái mà phải đào tạo lại, số ngày còn lại để khi đăng ký
--thi hợp lệ tính tới ngày hiện tại
--Thông tin hiển thị bao gồm: Mã khóa đào tạo, tên khóa đào tạo, ngayketthuckhoahoc, ngayhethandangkythi
Select khoadaotao.MaKhoa,TenKhoa,max(ngaysathach) as NgayKetThucKhoaHoc,add_months(max(ngaysathach),12) as NgayHetHanDangKyDuThi
from khoadaotao inner join dotsathach on khoadaotao.makhoa=dotsathach.makhoa
group by khoadaotao.makhoa,TenKhoa

--Câu 26: Cho biết những học sinh đã thi trượt lý thuyết và số điểm họ còn thiếu để vượt qua vòng thi:
--Thông tin hiển thị gồm: Số lý lịch, họ tên, mã hạng giấy phép lái xe, lần thi, điểm lý thuyết, số điểm lý thuyết còn thiếu
Select LyLich.SoLyLich,HoLot||' '||Ten as HoTen,KhoaDaotao.MaHangGPLX,LanThi,diemlythuyet,
(Select diemlttoithieu - diemlythuyet from hanggplx where mahanggplx=khoadaotao.mahanggplx) as diemlythuyetconthieu
from hosoduthi
inner join hosodangky on hosoduthi.mahosodangky=hosodangky.mahosodangky
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join lylich on lylich.solylich=hosodangky.solylich
where diemlythuyet <(select diemlttoithieu from hanggplx where mahanggplx=khoadaotao.mahanggplx)

--Câu 27: Cho biết co sở đào tạo cấp nhiều giấy phép lái xe nhất
-- Thông tin hiển thị bao gồm: Mã cơ sở đào tạo, tên cơ sở đào tạo, Số lượng giấy phép lái xe đã cấp
Select cosodaotao.MaCSDT,TenCSDT, count(Serial) as SoLuongGiayPhepLaiXeDaCap
From giaypheplaixe
inner join cosodaotao on giaypheplaixe.macsdt=cosodaotao.macsdt
group by cosodaotao.MaCSDT,TenCSDT
having count(Serial) = (Select max(count(Serial)) From giaypheplaixe
inner join cosodaotao on giaypheplaixe.macsdt=cosodaotao.macsdt
group by cosodaotao.MaCSDT,TenCSDT);

--Câu 28: Cho biết bằng lái xe có nhiều người thi trượt thực hành nhất
-- Thông tin hiển thị bao gồm: Mã Hạn Giấy Phép Lái Xe, Tên Hạng Giấy Phép Lái Xe, Số Người Thi Trượt Thực Hành
Select hanggplx.mahanggplx,tenhanggplx,
sum(case when hosoduthi.diemthuchanh<(select hanggplx.diemthtoithieu from hanggplx where mahanggplx=khoadaotao.mahanggplx) then 1
else 0
end) as SoLuongThiTruotThucHanh
from hosoduthi
inner join hosodangky on hosoduthi.mahosodangky=hosodangky.mahosodangky
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join hanggplx on hanggplx.mahanggplx=khoadaotao.mahanggplx
group by hanggplx.mahanggplx,tenhanggplx
having sum(case when hosoduthi.diemthuchanh<(select hanggplx.diemthtoithieu from hanggplx where mahanggplx=khoadaotao.mahanggplx) then 1 else 0 end)
= (select max(sum(case when hosoduthi.diemthuchanh<(select hanggplx.diemthtoithieu from hanggplx where mahanggplx=khoadaotao.mahanggplx) then 1 else 0
end))
from hosoduthi
inner join hosodangky on hosoduthi.mahosodangky=hosodangky.mahosodangky
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join hanggplx on hanggplx.mahanggplx=khoadaotao.mahanggplx
group by hanggplx.mahanggplx,tenhanggplx)

--Câu 29: Liệt kê ra các hồ sơ đăng ký dự thi cho biết hồ sơ đó đã quá hạn đợt sát hạch diễn ra hay chưa với mã đợt sát hạch do người dùng nhập vào
--Thông tin hiển thị bao gồm: MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao,ThongTinThoiHanDangKy
Select MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao,
(case when hosodangky.ngaydangky>(Select ngaysathach from dotsathach where hosodangky.madotsathach=dotsathach.madotsathach) then N'Hết hạn đăng ký' 
else N'Còn hạn đăng ký' end)
as ThongTinThoiHanDangKy
from hosodangky
where Upper(KhoaDaoTao)=Upper('&makhoadaotao')
order by mahosodangky;

--Câu 30: Biết thời gian bảo lãnh kết quả học tập của thí sinh là 1 năm tính từ ngày kết thúc khóa đào tạo (là ngày đợt sát hạch cuối cùng của khóa đào tạo kết thúc) 
-- tức là trong vòng 1 năm thí sinh có thể thi bằng giấy phép lái xe mà thí sinh đó tham gia đào tạo còn nếu quá 1 năm thí sinh sẽ phải học lại
--hãy cho biết những thí sinh đã đăng ký dự thi tuy nhiên ngày dự thi của họ đã quá 1 năm so với ngày kết thúc khóa đạo tạo
--Thông tin hiển thị bao gồm: SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai
Select HoSoDangKy.SoLyLich,HoLot,Ten,NgaySinh,GioiTinh,CMND,DiaChiThuongTru,SoDienThoai,hoctap.ngayketthuckhoadaotao,ngaysathach
From HoSoDangKy 
inner join 
dotsathach on hosodangky.madotsathach=dotsathach.madotsathach
inner join 
(Select khoadaotao.makhoa,max(ngaysathach)  as ngayketthuckhoadaotao from khoadaotao inner join dotsathach on khoadaotao.makhoa=dotsathach.makhoa
group by khoadaotao.makhoa) hoctap
 on hoctap.makhoa=hosodangky.khoadaotao
inner join LyLich on lylich.solylich=HoSoDangKy.SoLyLich
where add_months(hoctap.ngayketthuckhoadaotao,12)<dotsathach.ngaysathach;

--VIEW
--Câu 1: Tạo view vw_giaypheplaixe_lylich cho biết số lý lịch, họ tên, ngày sinh, giới tính, cmnd, mã hạng gplx người đó đang có, serial của gplx đó,thời hạn của gplx đó, ngày cấp và ngày hết hạn
Create or replace view vw_giaypheplaixe_lylich as
select LyLich.SoLyLich,HoLot||' '||Ten as HoTen,NgaySinh,GioiTinh,CMND,maHangGPLX,Serial,NgayCap,(select thoihan_nam from hanggplx where hanggplx.mahanggplx=giaypheplaixe.mahanggplx) as thoihan,
case
when  ((Select hanggplx.thoihan_nam from hanggplx where hanggplx.mahanggplx= giaypheplaixe.mahanggplx) is null) then N'Vĩnh viễn'
when ((Select hanggplx.thoihan_nam from hanggplx where hanggplx.mahanggplx= giaypheplaixe.mahanggplx) is not null)  then
N''||(add_months(NgayCap,(Select hanggplx.thoihan_nam from hanggplx where hanggplx.mahanggplx= giaypheplaixe.mahanggplx)*12))
end as NgayHetHan
from GiayPhepLaiXe inner join
LyLich on giaypheplaixe.solylich=lylich.solylich
order by holot||' '||ten,ngaysinh;

select * from vw_giaypheplaixe_lylich

--Câu 2: Tạo vw_lylich_ketquathi cho biết số lý lịch, họ tên, cmnd,mã cơ sở đào tạo, mã hồ sơ đăng ký,mã đợt sát hạch,ngày sát hạch
--lần thi, mã hạng giấy phép lái xe dự thi, điểm thực hành, điểm lý thuyết.
Create or replace view vw_lylich_ketquathi as
Select LyLich.SoLyLich,HoLot||' '||Ten as HoTen,cmnd,khoadaotao.macsdt,hosodangky.mahosodangky,dotsathach.madotsathach,ngaysathach,
KhoaDaotao.MaHangGPLX,LanThi,diemlythuyet,diemthuchanh
from hosoduthi
inner join hosodangky on hosoduthi.mahosodangky=hosodangky.mahosodangky
Inner join DotSatHach on dotsathach.madotsathach=hosodangky.madotsathach
inner join khoadaotao on khoadaotao.makhoa=dotsathach.makhoa
inner join lylich on lylich.solylich=hosodangky.solylich;

select * from vw_lylich_ketquathi

--Câu 3: Tạo view vw_hosodangky_dieukienduthi cho biết mã hồ sơ đăng ký, số lý lịch, ngày sinh, độ tuổi được thi, ngày sát hạch,
--mã giấy phép lái xe đăng ký thi, mã giấy phép lái xe đào tạo, điểm lý thuyết tối thiểu để đạt, điểm thực hành tối thiểu để đạt
create or replace view vw_hosodangky_dieukienduthi as
select hosodangky.mahosodangky,hosodangky.solylich, ngaysinh,duthi.ngaysathach, duthi.MaHangGPLX as MaHangGPLXDangKyThi,
khoadaotao.mahanggplx as MaHangGPLXDaoTao, duthi.dotuoitoithieu as dotuoiduocthi, diemlttoithieu,diemthtoithieu
From HoSoDangKy 
inner join 
(Select MaDotSatHach,Hanggplx.MaHangGPLX,dotuoitoithieu,ngaysathach, diemlttoithieu,diemthtoithieu
from DotSatHach inner join KhoaDaoTao on DotSatHach.MaKhoa=KhoaDaoTao.MaKhoa inner join hanggplx on hanggplx.mahanggplx=khoadaotao.mahanggplx) duthi
on hosodangky.madotsathach=duthi.madotsathach
inner join KhoaDaoTao on khoadaotao.makhoa=hosodangky.khoadaotao
inner join lylich on hosodangky.solylich=lylich.solylich;

select * from vw_hosodangky_dieukienduthi;

--Câu 4: Tạo view vw_ChiTietDotSatHach hiển thị các thông tin: Mã đợt sát hạch, Hạng GPLX thi, DoTuoiToiThieu
create or replace view vw_ChiTietDotSatHach as 
select madotsathach, hanggplx.mahanggplx as hanggplxthi,ngaysathach, dotuoitoithieu
from dotsathach
inner join khoadaotao on dotsathach.makhoa=khoadaotao.makhoa
inner join hanggplx on hanggplx.mahanggplx=khoadaotao.mahanggplx;

select * from vw_chitietdotsathach

--Câu 5: Tạo view vw_KhoaDaoTao_NgayKetThuc hiển thị các thông tin: Mã khóa đào tạo, mã hạng giấy phép lái xe, ngày kết thúc( tính từ ngày tổ chức
-- đợt sát hạch cuối cùng do khóa đào tạo đó tổ chức)
create or replace view vw_KhoaDaoTao_NgayKetThuc as
Select khoadaotao.makhoa,mahanggplx,max(ngaysathach)  as ngayketthuckhoadaotao from khoadaotao inner join dotsathach on khoadaotao.makhoa=dotsathach.makhoa
group by khoadaotao.makhoa,mahanggplx ;

select * from  vw_KhoaDaoTao_NgayKetThuc;

--Câu 6: Tạo view vw_Tinh_SoLuongThi hiển thị số lượng người đăng ký thi theo từng tỉnh. Bao gồm các thông tin: mã tỉnh, tên tỉnh, số lượng người đăng ký thi
create or replace view vw_Tinh_SoLuongThi as
select tinh.matinh,tentinh,count(lylich.solylich) as SoLuongNguoiDangKiThiGPLC
from tinh
inner join lylich on tinh.matinh=lylich.matinh
inner join hosodangky on lylich.solylich=hosodangky.solylich
group by tinh.matinh,tentinh;

select * from vw_Tinh_SoLuongThi
--Procedure
--Câu 1: Tạo thủ tục TaoHoSoDangKy với tham số truyền vào là số lý lịch, đợt sát hạch muốn đăng ký thi, khóa đào tạo đã tham gia học.
--Từ những tham số trên tạo hồ sơ đăng ký với ngày đăng ký là ngày hiện tại, mã hồ sơ đăng ký= số hồ sơ đăng ký lớn nhất +1
Create or replace procedure TaoHoSoDangKy(p_solylich lylich.solylich%type,p_madotsathach dotsathach.madotsathach%type, p_khoadaotao hosodangky.khoadaotao%type)
is
v_count_solylich number:=0;
v_count_madotsathach number:=0;
v_count_khoadaotao number:=0;
v_mahosodangky_new number;
e_solylich_invalid exception;
e_madotsathach_invalid exception;
e_khoadaotao_invalid exception;
begin
select count(solylich) into v_count_solylich from lylich where solylich=p_solylich;
if v_count_solylich=0 then raise e_solylich_invalid; end if;

select count(madotsathach) into v_count_madotsathach from dotsathach where madotsathach=p_madotsathach;
if v_count_madotsathach=0 then raise e_madotsathach_invalid; end if;

select count(makhoa) into v_count_khoadaotao from khoadaotao where makhoa=p_khoadaotao;
if v_count_khoadaotao=0 then raise e_khoadaotao_invalid; end if;

select count(mahosodangky)+1 into v_mahosodangky_new from hosodangky;
insert into hosodangky(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(v_mahosodangky_new,sysdate,null,null,p_solylich,p_madotsathach,p_khoadaotao);
dbms_output.put_line('Tạo hồ sơ đăng ký thành công');
exception 
when e_solylich_invalid then dbms_output.put_line('Số lý lịch không tồn tại');
when e_madotsathach_invalid then dbms_output.put_line('Mã đợt sát hạch không tồn tại');
when e_khoadaotao_invalid then dbms_output.put_line('Khóa đào tạo không tồn tại');
end;

exec taohosodangky('1','2','3');
exec taohosodangky('1101','1A111','1A11');

--Câu 2: Tạo thủ tục DanhSachGPLX_CMND cho phép người dùng nhập vào mã chứng minh nhân dân, hiện ra các giấy phép lái xe mà người đó đang sở hữu và ngày hết hạn của những
--giấy phép lái xe đó. Thông tin hiển thị gồm: mã hạng gplx, serial, ngày cấp, ngày hết hạn
Create or replace procedure DanhSachGPLX_CMND (p_cmnd lylich.cmnd%type)
is 
Cursor cur_danhsachgplx is select maHangGPLX,Serial,NgayCap,Ngayhethan
from vw_giaypheplaixe_lylich
where cmnd=p_cmnd;
v_record_cur cur_danhsachgplx%rowtype;
v_count number:=0;
begin
open cur_danhsachgplx;
loop
fetch cur_danhsachgplx into v_record_cur;
exit when cur_danhsachgplx%NOTFOUND;
v_count:=v_count+1;
 DBMS_OUTPUT.put_line('Mã hạng GPLX: ' ||v_record_cur.mahanggplx
                    || ' Serial: '||v_record_cur.serial
                    || ' Ngày cấp: ' ||v_record_cur.ngaycap
                    || ' Ngày hết hạn: '||v_record_cur.ngayhethan);
end loop;
if v_count=0 then DBMS_OUTPUT.put_line('Mã CMND đã nhập không có GPLX nào.'); end if;
close cur_danhsachgplx;
end;

exec DanhSachGPLX_CMND(&nhap_cmnd);

--Câu 3: Tạo thủ tục để cấp đổi giấy phép lái xe, có tham số truyền vào là CMND, mã hạng giấy phép lái xe muốn cấp đổi với 1 biến check.
--Kiểm tra người cấp đổi có giấy phép lái xe này không nếu có và chưa hết hạn thì đồng ý cấp đổi và trả về biển check=1
--còn không hết hạn hoặc chưa từng có bằng giấy phép lái xe thì từ chối cấp đổi là trả về biến check =0

Create or replace procedure CapDoiGPLX(p_cmnd in vw_giaypheplaixe_lylich.cmnd%type,p_mahanggplx  in vw_giaypheplaixe_lylich.mahanggplx%type,p_check out number)
as
v_record_ngaycap vw_giaypheplaixe_lylich.ngaycap%type;
v_record_thoihan vw_giaypheplaixe_lylich.thoihan%type;
v_hoten vw_giaypheplaixe_lylich.hoten%type;
begin
p_check:=0;
select ngaycap,thoihan,hoten into v_record_ngaycap,v_record_thoihan,v_hoten from  vw_giaypheplaixe_lylich where cmnd=p_cmnd and mahanggplx=p_mahanggplx;
if (v_record_thoihan is null) then p_check:=1; DBMS_OUTPUT.put_line('Đồng ý cấp đổi cho '||v_hoten||' hạng gplx: '|| p_mahanggplx); end if;
if (v_record_thoihan is not null) then
if add_months(v_record_ngaycap,v_record_thoihan*12)>= sysdate then p_check:=1; DBMS_OUTPUT.put_line('Đồng ý cấp đổi cho '||v_hoten||' hạng gplx: '|| p_mahanggplx); end if;
if add_months(v_record_ngaycap,v_record_thoihan*12)< sysdate then DBMS_OUTPUT.put_line('Bằng đã hết hạn không được cấp đổi'); end if;
end if;
EXCEPTION
WHEN NO_DATA_FOUND then
DBMS_OUTPUT.put_line('Người cấp đổi không có hạng giấy phép lái xe này. Từ chối cấp đổi');
end;

declare v_check number:=0;
begin
CapDoiGPLX('344686789','C',v_check);
end;

--Câu 4: Tạo thủ tục DoiSeiralGPLX Dùng thủ tục  CapDoiGPLX kiểm tra người đó có được cho phép cấp đổi giấy phép lái xe hay không nếu được cấp mới số serial cho hạng giấy phép lái xe
--của người xin cấp đổi. Số serial được cấp mới theo công thức: 
-- ngày + tháng + 2 số cuối năm cấp đổi.(ngày tháng năm của ngày cấp đổi tính tại ngày hiện tại)+hạng gplx+số lý lịch
--Tham số truyền vào là chứng minh nhân dân, mã hạng giấy phép lái xe cần cấp đổi.
Create or replace procedure DoiSeiralGPLX(p_cmnd in vw_giaypheplaixe_lylich.cmnd%type,p_mahanggplx  in vw_giaypheplaixe_lylich.mahanggplx%type)
is
v_check number:=0;
v_solylich lylich.solylich%type;
v_serial_new giaypheplaixe.serial%type;
begin
CapDoiGPLX(p_cmnd,p_mahanggplx,v_check);
select solylich into v_solylich from lylich where cmnd=p_cmnd;
if(v_check=0) then DBMS_OUTPUT.put_line('Không hợp lệ. Từ chối cấp đổi'); end if;
if(v_check=1) then
DBMS_OUTPUT.put_line('Đổi serial thành công');
update giaypheplaixe
set serial=to_char(extract(day from sysdate))||to_char(extract(month from sysdate))||substr(to_char(extract(year from sysdate)),3,2)||mahanggplx||solylich
where solylich=v_solylich and mahanggplx=p_mahanggplx;
select serial into v_serial_new from giaypheplaixe  where solylich=v_solylich and mahanggplx=p_mahanggplx;
DBMS_OUTPUT.put_line('Số serial mới là: '||v_serial_new);
end if;
end;

exec DoiSeiralGPLX('344686789','C');
exec DoiSeiralGPLX('213456789','D');

--Câu 5: Tạo thủ tục  KiemTraKetQuaThi  kiểm tra xem thí sinh có thi đậu hay không, thông qua một biến kiểm tra p_check trả về 1 là đậu, 0 là rớt, -1 nếu người đó chưa có kết quả thi.
-- Tham số truyền vào là: CMND, đợt sát hạch, lần thi
Create or replace procedure KiemTraKetQuaThi
(p_cmnd in vw_lylich_ketquathi.cmnd%type,
p_madotsathach in vw_lylich_ketquathi.madotsathach%type,
p_lanthi in vw_lylich_ketquathi.lanthi%type,
p_check out number)
is
v_diemlythuyet  vw_lylich_ketquathi.diemlythuyet%type;
v_diemthuchanh  vw_lylich_ketquathi.diemthuchanh%type;
v_diemlythuyettoithieu hanggplx.diemlttoithieu%type;
v_diemthuchanhtoithieu hanggplx.diemthtoithieu%type;
v_hoten vw_lylich_ketquathi.hoten%type;
begin
p_check:=1;
Select diemlythuyet, diemthuchanh,diemlttoithieu,diemthtoithieu,hoten into v_diemlythuyet,v_diemthuchanh,v_diemlythuyettoithieu,v_diemthuchanhtoithieu,v_hoten
from vw_lylich_ketquathi
inner join hanggplx on vw_lylich_ketquathi.mahanggplx=hanggplx.mahanggplx
where cmnd=p_cmnd and madotsathach=p_madotsathach and lanthi=p_lanthi;

if v_diemlythuyet is not null then 
if(v_diemlythuyet<v_diemlythuyettoithieu) then 
p_check:=0; 
DBMS_OUTPUT.put_line('Người thi '||v_hoten||' trượt lý thuyết. Điểm lý thuyết: '||v_diemlythuyet);
elsif v_diemthuchanh is not null then
if (v_diemthuchanh<v_diemthuchanhtoithieu) then 
p_check:=0; 
DBMS_OUTPUT.put_line('Người thi '||v_hoten||' trượt thực hành. Điểm ly thuyết: '||v_diemlythuyet||' Điểm thực hành: '||v_diemthuchanh);
end if;
end if;
end if;
if v_diemthuchanh is null and v_diemlythuyet is null then p_check:=-1; DBMS_OUTPUT.put_line('Người thi '||v_hoten||' chưa thi.'); 
end if;
EXCEPTION
WHEN NO_DATA_FOUND then
p_check:=0;
DBMS_OUTPUT.put_line('Không có hồ sơ dự thi của người có CMND: '||p_cmnd||' trong đợt thi '||p_madotsathach||' lần 2');
end;

declare v_check number:=0;
begin
kiemtraketquathi('182745559','1A111',1,v_check);
end;

--Câu 6: Tạo thủ tục DuyetKetQuaThi_CapGPLX sử dụng thủ tục KiemTraKetQuaThi để kiểm tra các hồ sơ dự thi có đạt không, nếu có cập nhật kết quả cho
--hồ sơ dự thi đó là Đậu, ngược lại là rớt. Nếu đậu cấp giấy phép lái xe cho người đó với ngày cấp được tính là sau 1 tháng kể từ ngày thi, 
--serial= ngày+ tháng+ 2 số cuối năm của ngày hiện tại + hạng giấy phép lái xe+ số lý lịch. Nếu người đó đã có giấy phép lái xe cùng hạng trong hồ sơ dự thi
-- thì cấp đổi bằng lái xe mới nếu còn thời hạn, từ chối nếu hết hạn.

Create or replace procedure DuyetKetQuaThi_CapGPLX
is
cursor cur_ketquathi is select SoLyLich,cmnd,macsdt,mahosodangky,mahanggplx,madotsathach,ngaysathach,LanThi,hoten
from vw_lylich_ketquathi;
v_cur_record cur_ketquathi%rowtype;
v_check number;
v_count number;
v_record_ngaycap vw_giaypheplaixe_lylich.ngaycap%type;
v_record_thoihan vw_giaypheplaixe_lylich.thoihan%type;
v_hoten vw_giaypheplaixe_lylich.hoten%type;
begin
 open cur_ketquathi;
   loop
   v_check:=0;
   fetch cur_ketquathi into v_cur_record;
   exit when cur_ketquathi%NOTFOUND;
    KiemTraKetQuaThi(v_cur_record.cmnd,v_cur_record.madotsathach,v_cur_record.lanthi,v_check);
    if v_check=-1 then
     update hosoduthi
    set hosoduthi.ketqua=null
   where hosoduthi.mahosodangky=v_cur_record.mahosodangky and hosoduthi.lanthi=v_cur_record.lanthi;
    end if;
    if v_check=0 then 
    update hosoduthi
    set hosoduthi.ketqua='Rớt'
    where hosoduthi.mahosodangky=v_cur_record.mahosodangky and hosoduthi.lanthi=v_cur_record.lanthi;
    end if;
    
    if v_check=1 then
    update hosoduthi
    set hosoduthi.ketqua='Đậu'
    where hosoduthi.mahosodangky=v_cur_record.mahosodangky and hosoduthi.lanthi=v_cur_record.lanthi;
    v_count:=0;
    select count(solylich) into v_count from giaypheplaixe where giaypheplaixe.mahanggplx=v_cur_record.mahanggplx and giaypheplaixe.solylich=v_cur_record.solylich;
    if v_count>0 then  
    select ngaycap,thoihan,hoten into v_record_ngaycap,v_record_thoihan,v_hoten from  vw_giaypheplaixe_lylich where cmnd=v_cur_record.cmnd and mahanggplx=v_cur_record.mahanggplx;
if (v_record_thoihan is null) then  DBMS_OUTPUT.put_line(v_hoten||' đã có giấy phép lái xe hạng '||v_cur_record.mahanggplx); end if;

if (v_record_thoihan is not null) then
if add_months(v_record_ngaycap,v_record_thoihan*12)>= sysdate then  DBMS_OUTPUT.put_line(v_hoten||' đã có giấy phép lái xe hạng '||v_cur_record.mahanggplx); end if;

if add_months(v_record_ngaycap,v_record_thoihan*12)< sysdate then 
update giaypheplaixe
set serial=to_char(extract(day from sysdate))||to_char(extract(month from sysdate))||substr(to_char(extract(year from sysdate)),3,2)||v_cur_record.mahanggplx||v_cur_record.solylich
where solylich=v_cur_record.solylich and mahanggplx=v_cur_record.mahanggplx;
end if;
end if;
 end if;
    if v_count=0 then
    insert into giaypheplaixe(SoLyLich,MaHangGPLX,Serial,NgayCap,MaCSDT)
    values (v_cur_record.solylich,
    v_cur_record.mahanggplx,
    to_char(extract(day from sysdate))||to_char(extract(month from sysdate))||substr(to_char(extract(year from sysdate)),3,2)||v_cur_record.mahanggplx||v_cur_record.solylich,
    add_months(v_cur_record.ngaysathach,1),
    v_cur_record.macsdt);
    DBMS_OUTPUT.put_line('Thêm thành công '||v_cur_record.hoten||' mã hạng gplx: '||v_cur_record.mahanggplx);
   
    end if;
  end if;
    end loop;
    
   close cur_ketquathi;
end;

exec duyetketquathi_capgplx

--FUNCTION
--Câu 1: Tạo hàm F_HSDK_KiemTraDoTuoi nhập vào số lý lịch, đợt sát hạch sau đó kiểm tra độ tuổi của người dự thi có đặt yêu cầu hay không, nếu đạt
--trả về 1 nếu không đạt trả về không.

Create or replace Function F_HSDK_KiemTraDoTuoi(p_solylich hosodangky.solylich%type,p_madotsathach hosodangky.madotsathach%type) 
return number 
is
v_ngaysinh vw_hosodangky_dieukienduthi.ngaysinh%type;
v_ngaysathach vw_hosodangky_dieukienduthi.ngaysathach%type;
v_dotuoiduocthi vw_hosodangky_dieukienduthi.dotuoiduocthi%type;
v_check number:=0;
begin 
select ngaysinh into v_ngaysinh
from lylich where solylich=p_solylich;
select ngaysathach,dotuoitoithieu into v_ngaysathach,v_dotuoiduocthi
from vw_chitietdotsathach where madotsathach=p_madotsathach;
if add_months(v_ngaysinh,v_dotuoiduocthi*12)<=v_ngaysathach then v_check:=1; end if;
return v_check;
end;

declare 
v_check number;
begin
v_check:=F_HSDK_KiemTraDoTuoi('0002','2D11');
if v_check=0 then dbms_output.put_line('Độ tuổi không đủ để dự thi'); else dbms_output.put_line('Độ tuổi đạt yêu cầu dự thi'); end if;
end;

--Câu 2: Tạo hàm F_HSDK_KiemTraHangGPLXDaoTao nhập vào mã đợt sát hạch, mã khóa đào tạo sau đó kiểm tra hạng giấy phép lái xe đào tạo có khớp với hạng giấy phép lái xe dự thi hay không
-- nếu khớp trả về 1 nếu không khớp trả về 0

Create or replace Function F_HSDK_KiemTraHangGPLXDaoTao(p_madotsathach hosodangky.madotsathach%type,p_khoadaotao hosodangky.khoadaotao%type) 
return number 
is
v_hanggplxduthi vw_hosodangky_dieukienduthi.mahanggplxdangkythi%type;
v_hanggplxdaotao vw_hosodangky_dieukienduthi.mahanggplxdaotao%type;
v_check number:=0;
begin 
select hanggplxthi into v_hanggplxduthi
from vw_chitietdotsathach where madotsathach=p_madotsathach;
select mahanggplx into v_hanggplxdaotao
from khoadaotao where makhoa=p_khoadaotao;
if v_hanggplxduthi=v_hanggplxdaotao then v_check:=1; end if;
return v_check;
end;

declare 
v_check number;
begin
v_check:=F_HSDK_KiemTraHangGPLXDaoTao('3B211','1A11');
if v_check=0 then dbms_output.put_line('Hạng GPLX dự thi và đào đạo không khớp'); else dbms_output.put_line('Hạng GPLX dự thi và đào đạo đạt yêu cầu'); end if;
end;


--Câu 3: Tạo hàm F_HSDK_KiemTraNangBang nhập vào số ly lịch, mã đợt sát hạch sau đó kiểm tra nếu người thi muốn thi bằng giấy phép lái xe hạng D phải nâng từ bằng C2 hoặc D,
-- Nếu đủ điều kiện trả về 1 không đủ trả về 0;

Create or replace Function F_HSDK_KiemTraNangBang(p_solylich hosodangky.solylich%type, p_madotsathach dotsathach.madotsathach%type) 
return number 
is
v_mahanggplxdangkythi vw_hosodangky_dieukienduthi.mahanggplxdangkythi%type;
v_count number:=0;
v_check number:=1;
begin 

select hanggplxthi into v_mahanggplxdangkythi
from vw_chitietdotsathach where madotsathach=p_madotsathach;
if(v_mahanggplxdangkythi='D') then
select count(mahanggplx) into v_count from giaypheplaixe where solylich=p_solylich and mahanggplx in ('B2','C'); 
if v_count=0 then v_check:=0; end if;

end if;
return v_check;
end;

declare 
v_check number;
begin
v_check:=F_HSDK_KiemTraNangBang('0002','2D11');
if v_check=0 then dbms_output.put_line('Không đủ điều kiện nâng bằng này'); else dbms_output.put_line('Đủ điều kiện thi/nâng bằng bằng này'); end if;
end;

--Câu 4: Tạo hàm F_HSDK_KiemTraTonTaiGPLX nhập vào mã hồ sơ sau đó kiểm tra nếu người thi đã có giấy phép lái xe và chưa hết hạn sẽ không được thi nữa trả về 0,
--ngược lại thì trả về 1

Create or replace Function F_HSDK_KiemTraTonTaiGPLX(p_solylich hosodangky.solylich%type, p_madotsathach dotsathach.madotsathach%type) 
return number 
is
v_mahanggplxdangkythi vw_hosodangky_dieukienduthi.mahanggplxdangkythi%type;
v_record_ngaycap vw_giaypheplaixe_lylich.ngaycap%type;
v_record_thoihan vw_giaypheplaixe_lylich.thoihan%type;
v_count number:=0;
v_check number:=1;
begin 

select hanggplxthi into v_mahanggplxdangkythi
from vw_chitietdotsathach where madotsathach=p_madotsathach;
 v_count:=0;
select count(solylich) into v_count from giaypheplaixe where giaypheplaixe.mahanggplx=v_mahanggplxdangkythi and giaypheplaixe.solylich=p_solylich;
if v_count >0 then
select ngaycap,thoihan into v_record_ngaycap,v_record_thoihan from  vw_giaypheplaixe_lylich where solylich=p_solylich and mahanggplx=v_mahanggplxdangkythi;
if (v_record_thoihan is null) then v_check:=0; end if;
if (v_record_thoihan is not null) then
if add_months(v_record_ngaycap,v_record_thoihan*12)>= sysdate then v_check:=0; end if;
if add_months(v_record_ngaycap,v_record_thoihan*12)< sysdate then v_check:=1; end if;
end if;
end if;
if v_count=0
then v_check:=1;
end if;
return v_check;
end;

declare 
v_check number;
begin
v_check:=F_HSDK_KiemTraTonTaiGPLX('0002','2D11');
if v_check=0 then dbms_output.put_line('Đã có bằng này (chưa hết hạn). Không được thi nữa.'); else dbms_output.put_line('Đủ điều kiện thi bằng này'); end if;
end;


--Câu 5: Tạo hàm F_HSDK_KiemTraBaoLuu nhập vào mã đợt sát hạch, mã khóa đào tạo cho biết người này có đủ điều kiện thi hay không dựa theo thời gian bảo lưu 
--của khóa học tập. Được biết khóa đào tạo kết thúc thì trong vòng 1 năm trở lại người thi có thể đăng ký sát hạch bất cứ lúc nào, còn quá 1 năm thì không
-- được phép tham gia sát hạch (ngày bắt đầu tính bảo lưuu là ngày được tính từ ngày kết thúc đợt sát hạch cuối cùng mà khóa đào tạo người đó học tổ chức)
-- Nếu người đó đủ điều kiện dự thi trả về 1 ngược lại trả về 0

Create or replace Function F_HSDK_KiemTraBaoLuu(p_madotsathach hosodangky.madotsathach%type,p_khoadaotao hosodangky.khoadaotao%type) 
return number 
is
v_ngayketthuc vw_khoadaotao_ngayketthuc.ngayketthuckhoadaotao%type;
v_ngaysathach dotsathach.ngaysathach%type;

v_check number:=1;
begin 
select ngayketthuckhoadaotao into v_ngayketthuc from vw_khoadaotao_ngayketthuc where makhoa=p_khoadaotao;
select ngaysathach into v_ngaysathach from dotsathach where madotsathach =p_madotsathach;
if add_months(v_ngayketthuc,12)>=v_ngaysathach then v_check:=1;
else v_check:=0; end if;

return v_check;
end;

declare 
v_check number;
begin
v_check:=F_HSDK_KiemTraBaoLuu('3B231','3B21');
if v_check=0 then dbms_output.put_line('Hạn bảo lưu đã hết. Không thể đăng ký sát hạch.'); else dbms_output.put_line('Đủ điều kiện sát hạch'); end if;
end;

--Câu 6: Tạo hàm F_HSDK_KiemTraSLDotSatHach cho nhập vào mã đợt sát hạch kiểm tra số lượng tham gia đơn đăng ký đã duyệt trong đợt sát hạch đó và cho
--biết còn có thể đăng ký nữa hay không? nếu còn đăng ký được trả về 1 nếu không trả về 0.

Create or replace Function F_HSDK_KiemTraSLDotSatHach(p_madotsathach hosodangky.madotsathach%type) 
return number 
is
v_soluongconlai dotsathach.soluongtoida%type;
v_check number:=1;
begin 
Select SoLuongToiDa- (Select count(solylich) from hosodangky where madotsathach=p_madotsathach) into v_soluongconlai
from dotsathach
where dotsathach.madotsathach=p_madotsathach;
if v_soluongconlai>0 then v_check:=1; else v_check:=0; end if;
return v_check;
end;


declare 
v_check number;
begin
v_check:=F_HSDK_KiemTraSLDotSatHach('3B232');
if v_check=0 then dbms_output.put_line('Đã nhận đủ hồ sơ. Không thế đăng ký thi'); else dbms_output.put_line('Có thể đăng ký.'); end if;
end;

--TRIGGER:
--Câu 1: Tạo ràng buộc ngày đăng ký phải nhỏ hơn ngày sát hạch khi sửa hoặc thêm vào bảng hồ sơ đăng ký

create or replace trigger trg_hosodangky_ngaydangky
before insert or update
on hosodangky
for each row
declare v_ngaysathach dotsathach.ngaysathach%type;
begin
select ngaysathach into v_ngaysathach
from dotsathach
where madotsathach= :new.madotsathach;
if(:new.ngaydangky >= v_ngaysathach) then
raise_application_error(-20001,'Đợt sát hạch đã diễn ra/kết thúc. Không thể đăng ký nữa. ');
end if;
end;

Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(14,'17/AUG/2021',null,null,'3221','1A111','1A11');


--Câu 2: Tạo ràng buộc nếu điểm lý thuyết không đạt hoặc đang null thì điểm thực hành phải là null vì người thi không đạt lý thuyết hoặc chưa thi lý thuyết
--không được phép thi thực hành.
create or replace trigger trg_hosoduthi_diemlythuyet
before insert or update
on hosoduthi
for each row
declare v_diemlythuyettoithieu hanggplx.diemlttoithieu%type;
begin
select diemlttoithieu into v_diemlythuyettoithieu
from vw_hosodangky_dieukienduthi
where mahosodangky= :new.mahosodangky;
if(:new.diemlythuyet < v_diemlythuyettoithieu or :new.diemlythuyet is null) then
if :new.diemthuchanh is not null then
raise_application_error(-20002,'Điểm lý thuyết không đạt hoặc chưa thi lý thuyêt thì không có điểm thực hành. '); end if;
end if;
end;

Insert Into HoSoDuThi(MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua)
values(7,2,null,1,null);

--Câu 3: Tạo ràng buộc một hồ sơ dự thi trong một đợt sát hạch chỉ có thể thi 2 lần ( 1 lần thi chính và 1 lần thi lại ) nếu quá 2 lần vẫn muốn thi lại phải lập hồ sơ khác
-- và đăng ký sát hạch trong một đợt sát hạch khác

create or replace trigger trg_hosoduthi_solanthi
before insert or update
on hosoduthi
for each row
declare v_count number;
begin
select count(mahosodangky) into v_count from hosoduthi where mahosodangky=:new.mahosodangky;

if(v_count>=2) then

raise_application_error(-20003,'Mỗi hồ sơ chỉ có thể tham gia 2 lần thi (1 lần chính và 1 lần thi lại). Nếu muốn thi lại tiếp phải taọ hồ sơ mới. '); 
end if;
end;

Insert Into HoSoDuThi(MaHoSoDangKy,LanThi,DiemLyThuyet,DiemThucHanh,KetQua)
values(1,3,null,null,null);

--Câu 4: Tạo ràng buộc nếu số lượng của đợt sát hạch đã duyệt đủ số lượng đơn đăng ký thì không nhận đơn nữa.
-- Có sử dụng Function F_HSDK_KiemTraSLDotSatHach để hỗ trợ

create or replace trigger trg_dotsathach_soluongduthi
before insert or update
on hosodangky
for each row
begin


if(F_HSDK_KiemTraSLDotSatHach(:new.madotsathach)=0) then

raise_application_error(-20004,'Đợt sát hạch đã nhận đủ hồ sơ. Không thể đăng ký thêm nữa '); 
end if;
end;

Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(18,'17/AUG/2021',null,null,'3221','3B232','3B23');

--Câu 5: Tạo ràng buộc vào hồ sơ đăng ký thi theo người dự thi: 1. Người đó phải đủ tuổi dự thi giấy phép lái xe muốn thi 2. Người đó phải chưa có bằng giấy phép lái xe này
-- hoặc có nhưng đã hết hạn.
--Trigger có sử dụng Function F_HSDK_KiemTraDoTuoi, F_HSDK_KiemTraTonTaiGPLX để hỗ trợ cài đặt.
create or replace trigger trg_hosodangkythi_nguoithi
before insert or update
on hosodangky
for each row
begin


if(F_HSDK_KiemTraDoTuoi(:new.solylich,:new.madotsathach)=0) then
raise_application_error(-20005,'Chưa đủ tuổi đăng ký thi hạng giấy phép lái xe này'); end if;

if(F_HSDK_KiemTraTonTaiGPLX (:new.solylich,:new.madotsathach)=0) then
raise_application_error(-20006,'Người dự thi đã có bằng lái xe này và chưa hết hạn. Không thể đăng ký thi. '); 
end if;
end;

--Kiểm thử

Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(18,'17/AUG/2020',null,null,'0002','2D11','2D1');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(18,'1/FEB/2020',null,null,'1101','1A111','1A11');


--Câu 6: Tạo ràng buộc trên hồ sơ đăng ký thi theo quy định được bộ công an đề ra:
--1. Khóa đào tạo phải đào tạo cùng hạng giấy phép với hạng giấy phép đợt sát hạch tổ chức.
--2. Khóa đào tạo kết thúc có thể bảo lưu trong vòng 1 năm, người thi có thể đăng ký sát hạch trong vòng 1 năm nếu muốn.
--3. Nếu người thi thi bằng hạng D thì không thể thi trực tiếp mà phải nâng từ bằng B2 hoặc C lên.
--Trigger có sử dụng Function F_HSDK_KiemTraHangGPLXDaoTao, F_HSDK_KiemTraBaoLuu, F_HSDK_KiemTraNangBang để hỗ trợ cài đặt.
create or replace trigger trg_hosodangkythi_quydinh
before insert or update
on hosodangky
for each row
begin

if(F_HSDK_KiemTraHangGPLXDaoTao(:new.madotsathach,:new.khoadaotao)=0) then
raise_application_error(-20007,'Giấy phép muốn sát hạch và giấy phép được đào tạo không khớp'); end if;

if(F_HSDK_KiemTraBaoLuu(:new.madotsathach,:new.khoadaotao)=0) then
raise_application_error(-20008,'Thời gian bảo lưu khóa học đã kết thúc. Phải tham gia khóa đào tạo khác để có thể đăng ký sát hạch '); 
end if;

if(F_HSDK_KiemTraNangBang(:new.solylich,:new.madotsathach)=0) then
raise_application_error(-20008,'Không thể thi trực tiếp bằng lái này. Phải có các bằng theo quy định mới có thể nâng lên. '); 
end if;
end;
--Kiểm thử
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(18,'1/FEB/2020',null,null,'1101','2C11','1A11');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(18,'1/FEB/2023',null,null,'1102','3B231','3B21');
Insert Into HoSoDangKy(MaHoSoDangKy,NgayDangKy,XetDuyet,LyDo,SoLyLich,MaDotSatHach,KhoaDaoTao)
values(18,'1/FEB/2020',null,null,'0002','2D11','2D1');