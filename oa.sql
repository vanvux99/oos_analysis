USE GHR_OOS_TESTNV
GO 

-- nhân sự mới
-- chưa ra đúng
SELECT CONCAT(nv.Ho, ' ', nv.HoTen) 'Họ và Tên', pb.Ten 'Phòng ban', nv.DienThoai 'Điện thoại', nv.Email 'Email', 
	CONVERT(DATE, nv.NgaySinh) 'Ngày sinh', CONVERT(DATE, nv.NgayBatDauLam) 'Ngày bắt đầu', 
	CONVERT(DATE, NgayKyHD) 'Ngày kí HĐ', TenLoaiHopDong 'Loại hợp đồng'
FROM dbo.NhanVien nv JOIN dbo.PhongBan pb ON pb.PhongBanID = nv.PhongBanID
	JOIN dbo.NS_HopDong ON NS_HopDong.NhanVienID = nv.NhanVienID
	JOIN dbo.NS_DsLoaiHopDong ON NS_DsLoaiHopDong.LoaiHopDongID = NS_HopDong.LoaiHopDongID
WHERE CONVERT(DATE,NgayBatDauLam) BETWEEN DATEADD(MONTH, -1, GETDATE())
	AND CONVERT(DATE, GETDATE())  
	AND NS_HopDong.XetDuyet = 1
	AND nv.XetDuyet = 1
GO 

-- nhân sự nghỉ việc

-- nhân sự thủ việc 
-- chưa ra đúng
SELECT CONCAT(nv.Ho, ' ', nv.HoTen) 'Họ và Tên', pb.Ten 'Phòng ban', nv.DienThoai 'Điện thoại', nv.Email 'Email', 
	CONVERT(DATE, nv.NgaySinh) 'Ngày sinh', CONVERT(DATE, nv.NgayBatDauLam) 'Ngày bắt đầu', 
	CONVERT(DATE, NgayKyHD) 'Ngày kí HĐ', TenLoaiHopDong 'Loại hợp đồng'
FROM dbo.NhanVien nv FULL JOIN dbo.PhongBan pb ON pb.PhongBanID = nv.PhongBanID
	FULL JOIN dbo.NS_HopDong ON NS_HopDong.NhanVienID = nv.NhanVienID
	FULL JOIN dbo.NS_DsLoaiHopDong ON NS_DsLoaiHopDong.LoaiHopDongID = NS_HopDong.LoaiHopDongID
WHERE NS_HopDong.LoaiHopDongID = 209 OR MaLoaiHD = 'HĐTV'
GO 

-- nhân sự chính thức - đúng
SELECT CONCAT(nv.Ho, ' ', nv.HoTen) 'Họ và Tên', pb.Ten 'Phòng ban', nv.DienThoai 'Điện thoại', nv.Email 'Email', 
	CONVERT(DATE, nv.NgaySinh) 'Ngày sinh', CONVERT(DATE, nv.NgayBatDauLam) 'Ngày bắt đầu', 
	CONVERT(DATE, NgayKyHD) 'Ngày kí HĐ', TenLoaiHopDong 'Loại hợp đồng'
FROM dbo.NhanVien nv JOIN dbo.PhongBan pb ON pb.PhongBanID = nv.PhongBanID
	JOIN dbo.NS_HopDong ON NS_HopDong.NhanVienID = nv.NhanVienID
	 JOIN dbo.NS_DsLoaiHopDong ON NS_DsLoaiHopDong.LoaiHopDongID = NS_HopDong.LoaiHopDongID
WHERE MaLoaiHD <> 'HĐTV'AND	 NS_HopDong.LoaiHopDongID <> 209
ORDER BY NgayBatDau DESC
GO 

-- đang thai sản

-- thay đổi hợp đồng -- đúng với đề bài 
SELECT DISTINCT CONCAT(nv.MaNhanVien, '-', nv.Ho, ' ', nv.HoTen) 'Họ và Tên',
                pb.Ten 'Phòng ban',
                nv.DienThoai 'Điện thoại',
                nv.Email 'Email',
                CONVERT(DATE, nv.NgaySinh) 'Ngày sinh',
                CONVERT(DATE, nv.NgayBatDauLam) 'Ngày bắt đầu',
                CONVERT(DATE, NgayKyHD) 'Ngày kí HĐ',
                TenLoaiHopDong 'Loại hợp đồng'
FROM
    dbo.NhanVien nv
    JOIN dbo.PhongBan pb ON pb.PhongBanID = nv.PhongBanID
    JOIN dbo.NS_HopDong ON NS_HopDong.NhanVienID = nv.NhanVienID
    JOIN dbo.NS_DsLoaiHopDong ON NS_DsLoaiHopDong.LoaiHopDongID = NS_HopDong.LoaiHopDongID
WHERE
    CONVERT(DATE, NgayKyHD)
    BETWEEN DATEADD(MONTH, -1, GETDATE()) AND CONVERT(DATE, GETDATE())
    AND NS_HopDong.XetDuyet = 1
    AND nv.XetDuyet = 1;
GO

-- đang nghỉ phép

-- đang đi công tác

-- điều chuyển bổ nhiệm - đúng với đề bài
SELECT DISTINCT CONCAT(nv.MaNhanVien, ' - ', nv.Ho, ' ', nv.HoTen) 'Họ và Tên',
                pb.Ten 'Phòng ban',
                nv.DienThoai 'Điện thoại',
                nv.Email 'Email',
                CONVERT(DATE, nv.NgaySinh) 'Ngày sinh',
                CONVERT(DATE, nv.NgayBatDauLam) 'Ngày bắt đầu',
                CONVERT(DATE, NgayKyHD) 'Ngày kí HĐ',
                TenLoaiHopDong 'Loại hợp đồng'
FROM
    dbo.NhanVien nv
    JOIN dbo.PhongBan pb ON pb.PhongBanID = nv.PhongBanID
    JOIN dbo.NS_HopDong ON NS_HopDong.NhanVienID = nv.NhanVienID
    JOIN dbo.NS_DsLoaiHopDong ON NS_DsLoaiHopDong.LoaiHopDongID = NS_HopDong.LoaiHopDongID
	JOIN dbo.NS_QTChuyenCanBo ON NS_QTChuyenCanBo.NhanVienID = nv.NhanVienID
WHERE
    CONVERT(DATE, NgayChuyen)
    BETWEEN DATEADD(MONTH, -1, GETDATE()) AND CONVERT(DATE, GETDATE())
    AND NS_HopDong.XetDuyet = 1
    AND nv.XetDuyet = 1;
GO 

-- sơ đồ tổ chức
CREATE PROCEDURE Proc_SoDoToChuc
    @PhongBanID AS INT
AS
BEGIN
	DECLARE @cnt INT = 1;

     SELECT DISTINCT CONCAT(nv.MaNhanVien, ' - ', nv.Ho, ' ', nv.HoTen) 'Họ và Tên',
                pb.Ten 'Phòng ban',
                nv.DienThoai 'Điện thoại',
                nv.Email 'Email',
                CONVERT(DATE, nv.NgaySinh) 'Ngày sinh',
                CONVERT(DATE, nv.NgayBatDauLam) 'Ngày bắt đầu',
                CONVERT(DATE, NgayKyHD) 'Ngày kí HĐ',
                TenLoaiHopDong 'Loại hợp đồng'
	FROM
		dbo.NhanVien nv
		JOIN dbo.PhongBan pb ON pb.PhongBanID = nv.PhongBanID
		JOIN dbo.NS_HopDong ON NS_HopDong.NhanVienID = nv.NhanVienID
		JOIN dbo.NS_DsLoaiHopDong ON NS_DsLoaiHopDong.LoaiHopDongID = NS_HopDong.LoaiHopDongID
		JOIN dbo.NS_QTChuyenCanBo ON NS_QTChuyenCanBo.NhanVienID = nv.NhanVienID
	WHERE
	-- làm sao để select ra tất cả các phòng ban con khi param truyền vào là phòng ban cha.
		WHILE @cnt <= (SELECT COUNT(*) FROM dbo.PhongBan WHERE PhongBanChaID = 2279)
		BEGIN
			nv.PhongBanID = (SELECT TOP @cnt PhongBanID FROM dbo.PhongBan WHERE PhongBanChaID = 2279)
		   SET @cnt = @cnt + 1;
		END
END
GO

-- thông tin tổng quan - chưa xong
CREATE PROCEDURE Proc_ThongTinTongQuan
    (@NhanVienID AS INT)
AS
BEGIN
    SELECT MaNhanVien 'Mã nhân viên', CONCAT(Ho, ' ', HoTen) 'Họ và tên', 
		CONVERT(DATE, NgaySinh) 'Ngày sinh', CONCAT(CMTND, ' - ', CONVERT(DATE, NgayCapCMT), ' - ', NoiCapCMT) 'CMTND', TinhTrangHonNhan 'Tình trạng hôn nhân',
		DienThoai 'Điện thoại', Email 'Email', DiaChi 'Địa chỉ', DiaChiThuongTru 'Địa chỉ thường trú', QueQuan 'Nguyên quán',
		TaiKhoanNganHang 'Số tài khoản', MaSoThue 'Mã số thuế'
	FROM dbo.NhanVien 

	SELECT * FROM dbo.NS_DsTrangThai
	--WHERE MaNhanVien = '0247306966642340000006'
END
GO

SELECT * FROM dbo.PhongBan
SELECT * FROM dbo.SYS_NguoiDung
SELECT * FROM dbo.NhanVien