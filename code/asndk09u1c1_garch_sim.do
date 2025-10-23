clear all
clear mata
clear matrix
macro drop _all
graph drop _all
set more off, permanently
cd "D:\OneDrive\Desktop\vietlod\SACHKTL\posts\asndk09u1\c1"
capture log using asndk09u1c1_sim, name(asndk09u1c1_sim) replace

* ==================================================
* MỤC ĐÍCH: Tạo dữ liệu chuỗi thời gian mô phỏng
* NỘI DUNG: Lợi suất chỉ số chứng khoán hàng ngày
* SỐ QUAN SÁT: 2500 (khoảng 10 năm giao dịch)
* ==================================================

* Bước 1: Xóa dữ liệu cũ và thiết lập số quan sát
clear
set obs 2500
set seed 123

* Bước 2: Tạo biến thời gian (ngày)
gen date = mdy(1, 1, 2010) + _n - 1
format date %td

* Bước 3: Khai báo dữ liệu chuỗi thời gian
tsset date

* Bước 4: Tạo một chuỗi giá theo quy trình bước ngẫu nhiên
* Giả định log của giá (ln_price) có một cú sốc cấu trúc
gen shock = (_n > 1500)
gen lnp = 7 + 0.0005*_n - 0.5*shock
replace lnp = lnp[_n-1] + rnormal(0, 0.02) if _n > 1

* Bước 5: Tạo biến lợi suất (return)
* Đây là biến chính chúng ta sẽ phân tích
gen ret = D.lnp

* Bước 6: Mô tả và lưu dữ liệu
describe
summarize lnp ret
* Lưu dữ liệu để sử dụng cho các bài sau
save "asndk09u1c1_garch_data.dta", replace


capture log close asndk09u1c1_sim
log2html asndk09u1c1_sim, replace 
