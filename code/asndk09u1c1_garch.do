clear all
clear mata
clear matrix
macro drop _all
graph drop _all
set more off, permanently
cd "D:\OneDrive\Desktop\vietlod\SACHKTL\posts\asndk09u1\c1"
capture log using asndk09u1c1, name(asndk09u1c1) replace


* ==================================================
* MỤC ĐÍCH: Chuẩn bị môi trường làm việc
* DỮ LIỆU: garch_data.dta
* ==================================================

* Tải dữ liệu và khai báo chuỗi thời gian
use "asndk09u1c1_garch_data.dta", clear
tsset date


* Vẽ đồ thị chuỗi lợi suất
tsline ret, title("Lợi suất hàng ngày") subtitle("Quan sát cụm biến động")
graph export asndk09u1c1_ret.png, replace

* Xem thống kê mô tả
summarize ret, detail

* Kiểm định tính dừng bằng kiểm định Dickey-Fuller tăng cường (ADF)
* H0: Chuỗi có nghiệm đơn vị (không dừng)
dfuller ret


* Vẽ lược đồ tự tương quan (ACF) và tự tương quan riêng phần (PACF)
ac ret, lags(20)
graph export asndk09u1c1_ret_ac.png, replace
pac ret, lags(20)
graph export asndk09u1c1_ret_pac.png, replace


* Chạy hồi quy cho phần trung bình (chỉ có hằng số)
quietly regress ret

* Kiểm định ARCH-LM với nhiều độ trễ
estat archlm, lags(1 2 3 5)


* Mô hình 1: GARCH(1,1)
arch ret, arch(1) garch(1)
estimates store m1_garch

* Mô hình 2: GJR-GARCH(1,1)
arch ret, arch(1) garch(1) tarch(1)
estimates store m2_gjr

* Mô hình 3: EGARCH(1,1)
arch ret, arch(1) garch(1) earch(1)
estimates store m3_egarch

* So sánh cả ba mô hình
estimates table m1_garch m2_gjr m3_egarch, stats(aic bic)

* Hiển thị lại kết quả của mô hình EGARCH đã lưu
estimates replay m3_egarch

* Dự báo phương sai có điều kiện (ht)
predict ht, variance

* Vẽ đồ thị phương sai có điều kiện
tsline ht, title("Phương sai có điều kiện ước lượng từ EGARCH(1,1)")
graph export asndk09u1c1_ht.png, replace




capture log close asndk09u1c1
log2html asndk09u1c1, replace 