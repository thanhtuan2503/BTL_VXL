	SELECT BIT P3.2
	 SLAV_0 EQU 30H
	 SLAV_1 EQU 31H
	 ORG 0
	 JMP MAIN
	 ORG 0030H
MAIN: 
	 MOV SP,#5FH
	 MOV SCON,#72H ;SPI mode 3 cho phép thu,TI=1
	 MOV TMOD,#20H ;Timer1 tạo baudrate
	 MOV TH1,#-3 ;BR=9600
	 MOV TL1,TH1
	 SETB TR1
Loop:
	 JB SELECT,SEL1 ;SELECT=1,chọn slaver1
	 MOV A,#SLAV_0 ;nạp địa chỉ slaver0
	 SETB SM2 ;SM2=1 để thu mã lệnh từ slaver được chọn 
	 SETB TB8 ;truyền mã lệnh 
	 ACALL PHAT ;phát địa chỉ slaver cần chọn
	 CLR A ;xóa A
	 ACALL THU ;thu địa chỉ slaver được chọn CJNE A,#SLAV_0,Loop ;kiểm tra đúng địa chỉ?
	 CLR SM2 ;đúng địa chỉ CLR TB8 ;chuẩn bị truyền data
TIEP:
	 MOV A,P1 ;nhập data từ P1
	 ACALL PHAT ;phát data
	 JZ Loop ;data=#0,ngừng truyền quay về từ đầu
	 ACALL THU ;thu data từ slaver
	 MOV P2,A ;xuất data thu được ra P2
	 JMP TIEP ;lặp vòng truyền tiếp
SEL1:
	 MOV A,#SLAV_1 ;nạp địa chỉ slaver1
	 SETB SM2 ;SM2=1 để thu mã lệnh từ slaver được chọn
	 SETB TB8 ;truyền mã lệnh
	 ACALL PHAT ; phát địa chỉ slaver cần chọn
	 CLR A ;xóa A
	 ACALL THU ; thu địa chỉ slaver được chọn
	 CJNE A,#SLAV_1,Loop ; kiểm tra đúng địa chỉ?
	 CLR SM2 ;đúng địa chỉ
	 CLR TB8 ; chuẩn bị truyền data
	 JMP TIEP ;nhảy đến truyền data
PHAT:
	 JNB TI,$
	 CLR TI
	 MOV SBUF,A
	 RET
THU:
	 JNB RI,$
	 CLR RI
	 MOV A,SBUF
	 RET
END