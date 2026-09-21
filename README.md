# Air Combat

Air Combat là game bắn máy bay không gian theo phong cách arcade. Người chơi điều khiển một chiến cơ bay xuyên qua các vùng không gian nguy hiểm, tự động khai hỏa, né đạn và chướng ngại vật, tiêu diệt đội hình địch, thu thập tài nguyên rồi đối đầu với các mini-boss và boss khổng lồ.

Game được xây dựng bằng Flutter và SpriteWidget, hỗ trợ giao diện toàn màn hình, hiệu ứng không gian, âm thanh chiến đấu, lưu tiến trình cục bộ và đồng bộ dữ liệu tài khoản lên đám mây.

## 1. Mục tiêu của trò chơi

Mục tiêu của mỗi lượt chơi là đi xa nhất có thể, đạt điểm số cao, kiếm nhiều xu và đánh bại các boss xuất hiện ở cuối màn. Khi kết thúc lượt chơi, người chơi dùng phần thưởng để:

- Nâng cấp laser.
- Nâng cấp các power-up.
- Mở khóa chiến cơ và vũ khí mới.
- Thu thập, trang bị và nâng cấp thiết bị.
- Hoàn thành nhiệm vụ ngày hoặc tuần.
- Cải thiện điểm cao trên bảng xếp hạng.

Vòng lặp chơi chính:

```text
Chọn cấp bắt đầu -> Điều khiển chiến cơ -> Tiêu diệt kẻ địch
-> Thu thập xu và power-up -> Đánh bại boss
-> Nhận điểm và phần thưởng -> Nâng cấp -> Chơi lại
```

## 2. Bắt đầu một lượt chơi

Từ màn hình chính, người chơi có thể chọn cấp bắt đầu đã mở khóa, chơi chế độ thường, vào chế độ sự kiện, quản lý kho đồ, xem nhiệm vụ, xem bảng xếp hạng hoặc đăng nhập để đồng bộ tiến trình.

Khi trận đấu bắt đầu, chiến cơ xuất hiện ở khu vực phía dưới màn hình. Giao diện chiến đấu hiển thị HP, điểm số, số xu và các hiệu ứng đang hoạt động.

## 3. Cách điều khiển

Người chơi chạm và kéo trên màn hình để điều khiển vị trí chiến cơ. Tàu có thể di chuyển sang trái, phải, lên hoặc xuống để né vật cản và đưa tàu vào vị trí bắn thuận lợi.

Chiến cơ tự động bắn khi người chơi đang điều khiển. Người chơi tập trung vào:

1. Giữ tàu tránh xa đạn và kẻ địch.
2. Đưa đường đạn đi qua nhiều mục tiêu nhất.
3. Di chuyển qua các vật phẩm để thu thập chúng.

Trận đấu có nút tạm dừng. Khi tạm dừng, chuyển động, đạn, boss, bộ đếm power-up và hiệu ứng chiến đấu đều dừng lại.

## 4. Cơ chế bắn

Ở trạng thái cơ bản, chiến cơ bắn hai tia laser cùng lúc. Tần suất bắn mặc định là một loạt đạn sau mỗi 20 khung hình, tương đương khoảng 3 lần mỗi giây ở 60 FPS.

Tốc độ khai hỏa thực tế được điều chỉnh bởi tốc độ bắn của chiến cơ, cấp laser, power-up Laser tốc độ, buff sau khi hạ boss và vũ khí đang trang bị.

## 5. Các loại vũ khí

| Vũ khí | Cách hoạt động | Hệ số sát thương |
| --- | --- | ---: |
| Laser cơ bản | Hai tia laser thẳng, cân bằng | 1.0x |
| Súng chùm | Ba viên đạn theo hình quạt | 0.8x |
| Tia xuyên phá | Tia năng lượng có khả năng xuyên mục tiêu | 2.0x |
| Tên lửa tự dẫn | Hai tên lửa tự tìm mục tiêu gần nhất | 1.5x |
| Súng xung kích | Bắn đạn năng lượng với nhịp rất nhanh | 0.75x |
| Pháo plasma | Hai phát plasma lớn, sát thương cao | 2.8x |
| Sóng Nova | Bốn luồng năng lượng tỏa rộng | 3.5x |

Power-up Laser bên và các nâng cấp đặc biệt có thể tạo thêm đạn hoặc mở rộng vùng tấn công.

## 6. Các chiến cơ

- **Chiến cơ Đánh Chặn:** Tàu mặc định, cân bằng và bền bỉ.
- **Chiến cơ Tốc Độ:** Tăng 20% tốc độ di chuyển.
- **Phượng Hoàng:** Tăng 30% tốc độ bắn, dùng pháo plasma.
- **Tàng Hình:** Tăng 40% tốc độ và giảm vùng va chạm còn khoảng 70%, nhưng bắn chậm hơn.
- **Hộ Vệ:** Chậm hơn nhưng tăng 50% tốc độ bắn, thiên về hỏa lực mạnh.

Chiến cơ mới được mở khóa bằng xu. Tàu nhanh phù hợp với lối chơi né tránh, còn tàu hạng nặng phù hợp với lối chơi tấn công trực diện.

## 7. Cấu trúc màn chơi

Mỗi cấp độ gồm 9 phân đoạn. Màn chơi cuộn liên tục và lần lượt đưa vào các nhóm đối thủ:

1. Thiên thạch hoặc chướng ngại vật.
2. Đội hình tàu trinh sát.
3. Kẻ địch tinh nhuệ ở các cấp cao hơn.
4. Một nhịp chướng ngại nhẹ.
5. Đội hình tàu hủy diệt.
6. Một đợt thiên thạch.
7. Đội hình hỗn hợp.
8. Đợt tăng cường ở các cấp cao.
9. Mini-boss hoặc boss cuối cấp.

Ở cấp thường, phân đoạn cuối là mini-boss. Cứ mỗi cấp thứ 10, cuộc chạm trán được nâng thành boss đầy đủ. Khi boss xuất hiện, tốc độ cuộn có thể giảm hoặc dừng; cấp tiếp theo chỉ tiếp tục sau khi boss bị đánh bại.

## 8. Kẻ địch và boss

Người chơi phải đối mặt với thiên thạch, tàu trinh sát, tàu hủy diệt, kẻ địch tinh nhuệ và các loại đạn laser của địch. Mỗi loại có tốc độ, HP và cách tấn công khác nhau.

Boss được luân phiên giữa nhiều kiểu chiến đấu như bắn laser, triệu hồi trợ thủ, tạo đạn tỏa tròn, di chuyển bất thường hoặc tấn công diện rộng. Boss có thanh máu riêng và được giữ lại trên màn hình cho đến khi bị tiêu diệt.

## 9. HP, va chạm và sát thương

Chiến cơ mặc định bắt đầu với 3 HP. Giáp và một số trang bị có thể tăng HP tối đa hoặc giảm sát thương nhận vào.

Khi va chạm:

- Khiên sẽ chặn sát thương.
- Nếu không có khiên, sát thương đi qua lớp giảm sát thương của giáp.
- Sát thương lẻ được tích lũy, không bị bỏ qua.
- Sau khi trúng đòn, tàu có một khoảng thời gian bất tử ngắn.
- Bị trúng đòn sẽ làm mất combo.

Khi HP về 0, tàu phát nổ và lượt chơi kết thúc sau khi xử lý cơ hội hồi sinh.

## 10. Power-up

Người chơi chỉ cần điều khiển tàu đi qua vật phẩm để nhặt power-up:

- **Khiên:** Vô hiệu hóa sát thương tạm thời.
- **Laser bên:** Bổ sung hai tia laser ở hai bên.
- **Laser tốc độ:** Giảm thời gian chờ giữa các loạt đạn.
- **Tăng tốc:** Tăng mạnh tốc độ di chuyển và tạo lớp bảo vệ tạm thời.
- **Hồi máu:** Khôi phục 1 HP, không vượt quá HP tối đa.
- **Nam châm:** Hút xu và vật phẩm ở khoảng cách gần trong 10 giây.
- **Nuke:** Gây sát thương tối đa lên các mục tiêu địch thông thường trên màn hình.

Khiên, Laser tốc độ, Laser bên và Tăng tốc có thể nâng cấp vĩnh viễn. Hồi máu, Nam châm và Nuke chủ yếu nhận được từ vật phẩm rơi trong trận.

## 11. Cách tính điểm

Điểm được cộng khi tiêu diệt một mục tiêu. Mục tiêu thường có điểm cơ bản dựa trên HP, còn elite và boss có phần thưởng cố định.

```text
Điểm cơ bản của kẻ địch thường = làm tròn lên (HP tối đa x 10)
Điểm mini-boss = 180 + cấp độ x 35
Điểm boss = 600 + cấp độ x 100
```

### Hệ số combo

Mỗi lần hạ mục tiêu, combo tăng trước khi tính điểm:

```text
Hệ số combo = 1 + (số combo x 0.05)
Điểm nhận được = làm tròn (Điểm cơ bản x Hệ số combo)
```

Combo tối đa là 20, tương đương hệ số tối đa 2.0 lần điểm cơ bản. Ví dụ, mục tiêu có 100 điểm cơ bản được tính như sau:

- Combo 1: `100 x 1.05 = 105 điểm`.
- Combo 2: `100 x 1.10 = 110 điểm`.
- Combo 20: `100 x 2.00 = 200 điểm`.

Người chơi có khoảng 4 giây để hạ mục tiêu tiếp theo. Hết thời gian hoặc bị trúng đòn sẽ đưa combo về 0 và hệ số về 1.0.

Khi tiêu diệt kẻ địch, người chơi cũng nhận kinh nghiệm. Kinh nghiệm của kẻ địch thường dựa trên HP và được giới hạn từ 1 đến 50. Buff chiến đấu không tự động nhận từ mốc kinh nghiệm; buff trong lượt được trao sau khi hạ boss.

## 12. Xu và phần thưởng

Xu rơi ra từ các mục tiêu và bay về bảng xu khi được thu thập. Chế độ sự kiện áp dụng hệ số xu cao hơn chế độ thường.

Xu dùng để nâng cấp laser, nâng cấp power-up, mua chiến cơ, mua một số thiết bị và mở khóa vũ khí. Ngoài xu, người chơi còn có thể nhận đá năng lượng, lõi năng lượng, thiết bị và buff boss.

## 13. Buff sau khi hạ boss

Sau khi đánh bại mini-boss hoặc boss, game có thể tạm dừng để người chơi chọn một buff:

- **Buff xanh:** Tăng sát thương vũ khí.
- **Buff tím:** Tăng tốc độ bắn.
- **Buff vàng hiếm:** Tăng sát thương vũ khí nhiều hơn buff thông thường.

Buff cộng dồn trong cùng một lượt chơi và được thiết lập lại khi bắt đầu lượt mới.

## 14. Nâng cấp laser và power-up

Sát thương laser được tính theo cấp laser:

```text
Hệ số sát thương laser = 1.22 ^ cấp laser
Giá nâng cấp laser = làm tròn (750 x 1.45 ^ cấp laser hiện tại)
Giá nâng cấp power-up = (cấp hiện tại + 1) x 50 + 50
```

Thời gian tác dụng cơ bản của hầu hết power-up là 300 khung hình, khoảng 5 giây ở 60 FPS. Mỗi cấp cộng thêm 50 khung hình. Riêng Tăng tốc có thời gian cơ bản 150 khung hình và cộng thêm 25 khung hình mỗi cấp.

## 15. Trang bị và drone

Người chơi có thể lắp một vật phẩm cho mỗi nhóm:

- **Lõi:** Tăng sát thương.
- **Giáp:** Tăng HP và giảm sát thương nhận vào.
- **Động cơ:** Tăng tốc độ di chuyển.
- **Drone:** Tự động tấn công kẻ địch.

Trang bị có bốn độ hiếm: thường, hiếm, sử thi và huyền thoại. Drone có thể bắn thường, bắn nhanh hoặc sử dụng đạn tự dẫn. Drone cấp sử thi và huyền thoại có thể tạo thêm một trợ thủ thứ hai.

## 16. Nhiệm vụ, sự kiện và xếp hạng

Nhiệm vụ ngày và tuần yêu cầu người chơi hoàn thành số lượt chơi, tiêu diệt kẻ địch hoặc thu thập xu. Hoàn thành nhiệm vụ sẽ nhận phần thưởng.

Chế độ sự kiện có bối cảnh riêng, kẻ địch mạnh hơn, nhiều đợt tấn công liên tiếp, boss xuất hiện dày hơn và hệ số xu cao hơn. Đây là chế độ phù hợp để thử bộ trang bị mạnh và tối ưu điểm số.

Điểm cao nhất được lưu lại để phục vụ bảng xếp hạng và so sánh thành tích.

## 17. Game over và hồi sinh

Khi HP về 0, chiến cơ phát nổ và phần lớn kẻ địch được đóng băng để xử lý kết thúc lượt. Người chơi có thể được cung cấp một cơ hội hồi sinh thông qua phần thưởng quảng cáo.

Nếu hồi sinh thành công, tàu trở lại với khoảng 50% HP tối đa, nhận một khoảng thời gian bất tử ngắn và tiếp tục từ vị trí hiện tại. Nếu không hồi sinh, lượt chơi kết thúc và game ghi nhận điểm cuối, số xu thu được cùng cấp độ cao nhất đã đạt.

## 18. Lưu và đồng bộ tiến trình

Game lưu xu, tài nguyên, cấp laser, cấp power-up, cấp bắt đầu đã mở khóa, chiến cơ, vũ khí, thiết bị, trang bị đang dùng, điểm số và nhiệm vụ. Khi đăng nhập, dữ liệu có thể được tải từ đám mây và đồng bộ lại với bộ nhớ trên thiết bị.

## 19. Chiến thuật gợi ý

- Luôn giữ chiến cơ ở khu vực có đủ khoảng trống để phản ứng với đạn.
- Tập trung né tránh vì bị trúng đòn sẽ mất combo.
- Dùng khiên trước các đợt địch dày hoặc đòn diện rộng của boss.
- Dùng Nuke khi màn hình có quá nhiều mục tiêu.
- Ưu tiên nâng laser để tăng sát thương ổn định trong mọi lượt.
- Chọn tàu nhanh cho lối chơi né tránh hoặc tàu hỏa lực mạnh cho lối chơi tấn công.
- Dùng Nam châm khi nhiều xu hoặc vật phẩm nằm rải rác.
- Sau mỗi boss, chọn buff phù hợp với vũ khí và trang bị đang sử dụng.

## 20. Tóm tắt trải nghiệm

Air Combat kết hợp lối chơi bắn máy bay dễ tiếp cận với hệ thống phát triển lâu dài. Người chơi chỉ cần chạm và kéo để bay, nhưng để đạt điểm cao cần duy trì combo, tận dụng power-up, lựa chọn tàu và vũ khí phù hợp, xây dựng trang bị hiệu quả và kiểm soát từng trận đấu boss.