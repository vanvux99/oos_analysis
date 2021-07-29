declare @phongbanid int =588
declare @nam int =2021
declare @thang int =5
declare @dangnhapid int = 20

select isnull([NET],0) as Amount,
case when (ISNULL([PHUCAP],0)=0) then N'VPCL Salary for '+substring(convert(nvarchar, convert(date, cast(@nam as nvarchar(4)) + '-' + cast(@thang as nvarchar(2)) + '-01'), 106),4,3) +' '+ right(cast(@nam as nvarchar),2)
else N'VPCL Salary and Housing Allowance for '+SUBSTRING(convert (nvarchar, convert(date, cast(@nam as nvarchar(4))+'-'+ cast(@thang as nvarchar(2))+'-01'),106),4,3) +' '+right(cast (@nam as nvarchar),2) end 
as N'Description', *
-- mô tả này theo 1 mẫu có sẵn, VPCL Salary for + tháng năm, hoặc VPCL Salary and Housing Allowance for + tháng năm
-- chuyển tháng và năm sang nvarchar để có thể ép thành date
from(
select @thang as Thang, @nam as Nam, -- bên dưới phần payroll list 
NhanVien.MaNhanVien, NhanVien.Ho+' '+NhanVien.HoTen as HoVaTen, NhanVien.TenNganHang, NhanVien.tenchutaikhoan, NhanVien.TaiKhoanNganHang,
NS_TL_LoaiLuong.MaSo, NS_TL_ChiTietLuong.TienLuong
FROM    ns_tl_bangluong 
INNER JOIN nhanvien ON NS_TL_BangLuong.NhanVienID = nhanvien.NhanVienID 
INNER JOIN PhongBan ON NS_TL_BangLuong.PhongBanID = PhongBan.PhongBanID 
INNER JOIN ns_tl_chitietluong ON NS_TL_ChiTietLuong.BangLuongID = NS_TL_BangLuong.BangLuongID 
INNER JOIN NS_TL_LoaiLuong ON NS_TL_ChiTietLuong.LoaiLuongID = NS_TL_LoaiLuong.LoaiLuongID 
WHERE ((nhanvien.nghiviec = 0 or nhanvien.nghiviec is null)-- nếu 1 giá trị = 0 nên viết = 0 hoặc is null
or (nhanvien.nghiviec = 1 and ((year(ngaynghiviec)>@nam) or (year(ngaynghiviec)=@nam and month(ngaynghiviec)>= @thang)))) 
-- nếu nhân viên đã nghỉ việc thì thời gian phải lớn hơn thời gian xét, nhân viên nghỉ việc rồi nhưng thời gian chưa tới thì vẫn tính lương bình thường 
-- dùng cho nhân viên chưa nghỉ việc hoặc đã nghỉ việc nhưng vẫn làm trong thời gian tính lương
and NS_TL_BangLuong.Thang = @thang and NS_TL_BangLuong.Nam = @nam
and NS_TL_BangLuong.phongbanid in (SELECT valu FROM [dbo].[GetPhongBanChild_WUser] (@phongbanid,@dangnhapid) ) -- proc này 
) A
-- mã số ?
pivot (max(TienLuong) for MaSo in ([BHTN_CTY],[BHTN_NLD],[BHXH_CTY],[BHXH_NLD],[BHYT_CTY],[BHYT_NLD],[CDP],[GT_GC],[GT_GCBT],[TOT],[L_TOT],[L_TOT_TT],
[LCB],[LCB_TNC],[PHUCAP],[LDK],[ML_BHTN],[ML_BHXH],[NCP],[NCTC],[NCTL],[NCTT],[NET],[SNPT],[T_BH],[TNTT],[TTNCN],[THUONG],[TRUYTHU],[BUTRU],[TRUYLINH],
[OT_T],[OT_TD],[OT_W],[OT_WD],[OT_L],[OT_LD],[LOT_T],[LOT_TD],[LOT_W],[LOT_WD],[LOT_L],[LOT_LD],[OT_EX],[LOT_EX],[NB],[LNB]))p
-- chuyển hết các giá trị này thành trường, sử dụng pivot
order by manhanvien ASC

SELECT * FROM dbo.NS_TL_LoaiLuong