# Kế hoạch phát triển chế độ nhiệm vụ mới

## Mục tiêu

Phát triển một chế độ chơi có mục tiêu ngắn hạn rõ ràng, trận đấu có cao trào và mỗi lượt để lại tiến triển đáng nhớ. Chế độ mới bổ sung cho Endless và Boss Rush; không thay thế hai chế độ đang có.

## Nhận định về vòng chơi hiện tại

- Người chơi điều khiển chiến cơ, né đạn và chướng ngại trong khi tàu tự khai hỏa.
- Normal Mode tiếp tục sinh các đoạn thiên thạch, đội hình địch và mini-boss theo chu kỳ chín đoạn.
- XP draft và buff sau boss đã tạo lựa chọn trong trận, nhưng chủ yếu thay đổi chỉ số.
- Điểm cao và tiền xu tạo động lực dài hạn, nhưng chưa cho người chơi một mục tiêu nhiệm vụ cụ thể để theo đuổi trong từng lượt.

Vì vậy, ưu tiên là tăng mục tiêu, lựa chọn chiến thuật và cao trào; chưa cần mở rộng số lượng tàu hay loại địch trước.

## Đề xuất: Chiến dịch Khe Nứt

**Mô tả một câu:** Phá các mỏ neo đang giữ khe nứt mở, chọn đường tiến công, rồi đánh bại boss trước khi hạm đội xâm lược tràn qua.

### Vòng chơi dự kiến

1. Chọn nhiệm vụ và xem mục tiêu cùng phần thưởng.
2. Chiến đấu qua các khu vực có nhịp độ và đội hình khác nhau.
3. Tìm và phá mỏ neo khe nứt để làm boss cuối yếu đi.
4. Giữa các khu vực, chọn tuyến an toàn để hồi phục hoặc tuyến nguy hiểm để nhận thêm phần thưởng.
5. Chọn nâng cấp trong trận; tại mốc phù hợp, chọn một tiến hóa vũ khí làm thay đổi kiểu bắn.
6. Đánh boss có các pha tấn công được báo trước, nhận kết quả nhiệm vụ và mở khóa nội dung tiếp theo.

### Màn chơi đầu tiên: “Tắt tiếng Khe Nứt”

Mục tiêu là hoàn thành một lượt khoảng 4–6 phút, gồm ba khu vực chiến đấu và một boss cuối.

| Nhịp | Nội dung | Mục đích |
| --- | --- | --- |
| Mở màn | Hướng dẫn điều khiển bằng một đợt địch nhẹ; hiển thị mục tiêu “Phá 3 mỏ neo” | Cho người chơi biết cần làm gì ngay trong trận |
| Khu vực 1 | Đội hình trinh sát bảo vệ mỏ neo đầu tiên | Dạy cách ưu tiên mục tiêu |
| Khu vực 2 | Địch tấn công dày hơn; chọn tuyến hồi phục hoặc tuyến có elite và thưởng tốt hơn | Tạo lựa chọn có đánh đổi |
| Khu vực 3 | Mỏ neo cuối cùng và một đợt địch phối hợp | Tạo đà cho cao trào |
| Boss cuối | Boss có hai hoặc ba pha; mỗi mỏ neo còn lại cấp cho boss một khả năng bổ sung | Khiến mục tiêu phụ có tác động thấy được |
| Kết quả | Tóm tắt mục tiêu, thành tích, phần thưởng và tiến độ mở khóa | Giúp thất bại hay chiến thắng đều có ý nghĩa |

Không đặt giới hạn thời gian cho bản đầu. Độ khó của boss thay đổi theo số mỏ neo chưa bị phá để người chơi hiểu rõ mối liên hệ giữa mục tiêu phụ và trận cuối.

## Các nguyên tắc thiết kế

- **Mục tiêu xuất hiện ngay trong HUD:** luôn cho biết còn bao nhiêu mỏ neo, khu vực hiện tại và điều kiện để làm boss yếu đi.
- **Mục tiêu phụ tạo quyết định:** mỏ neo phải nằm trong đội hình nguy hiểm vừa đủ để người chơi cân nhắc đổi vị trí và ưu tiên bắn.
- **Lựa chọn có đánh đổi thật:** tuyến an toàn hồi phục hoặc bổ sung phòng thủ; tuyến nguy hiểm có elite và phần thưởng nâng cấp tốt hơn.
- **Tiến hóa thay đổi cách chơi:** ít nhất một lựa chọn làm đổi hình dạng hoặc hành vi đạn, thay vì chỉ tăng sát thương vài phần trăm.
- **Boss báo trước đòn đánh:** hiệu ứng và âm thanh cảnh báo cho người chơi thời gian né hoặc dùng kỹ năng.
- **Không phạt quá nặng:** thất bại vẫn ghi nhận tài nguyên đã kiếm và một phần tiến độ nhiệm vụ; chiến thắng mới mở khóa đầy đủ phần thưởng đặc biệt.

## Các giai đoạn phát triển

### Giai đoạn 0 — Chốt trải nghiệm

- Chốt tên, mục tiêu nhiệm vụ, thời lượng mục tiêu và một câu giới thiệu chế độ.
- Viết sơ đồ ba khu vực, mỏ neo và các pha boss trước khi thêm content.
- Chọn một loại mỏ neo và một boss để làm vertical slice.
- Xác định phần thưởng chiến thắng, thất bại và điều kiện mở nhiệm vụ kế tiếp.

**Hoàn tất khi:** đội phát triển có thể mô tả mục tiêu mỗi khu vực và lý do người chơi muốn phá từng mỏ neo.

### Giai đoạn 1 — Vertical slice chơi được

- Thêm điểm vào Chiến dịch Khe Nứt từ màn hình hangar.
- Tạo luồng bắt đầu nhiệm vụ, trạng thái hoàn thành và trạng thái thất bại.
- Xây dựng một nhiệm vụ có ba khu vực, ba mỏ neo và một boss.
- Thêm HUD nhiệm vụ và hiệu ứng xác nhận khi phá mỏ neo.
- Boss thay đổi khả năng theo số mỏ neo còn lại.
- Giữ nguyên Normal Mode và Event/Boss Rush.

**Hoàn tất khi:** người chơi mới có thể vào trận, hiểu mục tiêu trong vài giây, hoàn thành hoặc thất bại, rồi quay lại hangar mà không cần biết trước quy tắc.

### Giai đoạn 2 — Lựa chọn làm thay đổi lượt chơi

- Thêm lựa chọn tuyến an toàn/nguy hiểm giữa các khu vực.
- Tái sử dụng XP draft hiện có, nhưng thêm một tiến hóa cho vũ khí đang trang bị.
- Tiến hóa đầu tiên phải tạo khác biệt nhìn thấy được, ví dụ đạn tách đôi sau va chạm hoặc tia xuyên để lại vùng sát thương.
- Cân bằng để lựa chọn tuyến nguy hiểm đáng cân nhắc, không luôn là lựa chọn tối ưu.

**Hoàn tất khi:** hai lượt chơi có thể tạo ra khác biệt về đường đi hoặc cách tấn công, không chỉ chênh lệch chỉ số.

### Giai đoạn 3 — Phần thưởng và tiến trình

- Trả thưởng nhiệm vụ theo mục tiêu hoàn thành, mỏ neo phá được và thành tích trong trận.
- Cho thất bại phần thưởng cơ bản; dành bản thiết kế, lõi khe nứt hoặc mở khóa cho chiến thắng.
- Lưu cấp nhiệm vụ, phần thưởng đã nhận và nội dung đã mở khóa.
- Thêm màn hình kết quả với nút chơi lại và nút quay về hangar.
- Thêm migration cho save trước khi lưu dữ liệu chiến dịch mới.

**Hoàn tất khi:** người chơi hiểu mình nhận được gì, còn thiếu điều kiện gì và lần chơi sau có thể tiến tới mục tiêu nào.

### Giai đoạn 4 — Kiểm thử trải nghiệm và hoàn thiện

- Quan sát người chơi mới ở 30 giây đầu: họ có hiểu mục tiêu và cách di chuyển để đạt mục tiêu không?
- Ghi nhận thời lượng trận, số mỏ neo bị phá, số lần chọn mỗi tuyến, tỉ lệ đánh bại boss và tỉ lệ chơi lại.
- Nếu đa số bỏ qua mỏ neo, làm rõ lợi ích hoặc cải thiện vị trí/telegraph trước khi tăng phần thưởng.
- Nếu boss quá khó khi còn mỏ neo, giảm áp lực đạn hoặc kéo dài khoảng né; không giải quyết bằng cách chỉ tăng HP người chơi.
- Rà soát localization Việt/Anh, kích thước màn hình, khả năng đọc HUD, âm thanh và nhịp hiệu ứng.

**Hoàn tất khi:** người chơi hiểu nhiệm vụ, có ít nhất một quyết định đáng nhớ trong trận và có lý do cụ thể để chơi lại.

## Phạm vi MVP

Bao gồm:

- Một nhiệm vụ hoàn chỉnh.
- Một loại mỏ neo.
- Một boss có các pha liên kết với số mỏ neo còn lại.
- Một lựa chọn tuyến giữa trận.
- Một tiến hóa vũ khí.
- HUD nhiệm vụ, màn hình kết quả và phần thưởng cơ bản.
- Việt hóa và tiếng Anh.

Chưa làm trong MVP:

- Nhiều chương truyện hoặc bản đồ nhánh lớn.
- Bộ sưu tập tiến hóa cho toàn bộ vũ khí.
- Nhiệm vụ hằng ngày riêng cho chế độ mới.
- Multiplayer, bảng xếp hạng mới hoặc hệ thống gacha mới.
- Thêm nhiều tàu/địch trước khi vòng chơi đầu tiên được kiểm chứng.

## Khu vực code dự kiến

- `lib/view/game/game_demo.dart`: điểm vào và chọn chế độ.
- `lib/controller/game/game_demo_node.dart`: tiến trình nhiệm vụ, chuyển khu vực và điều kiện hoàn thành.
- `lib/controller/game/game_object_factory.dart` cùng `lib/controller/game/game_objects.dart`: mỏ neo và đội hình riêng cho nhiệm vụ.
- `lib/view/game/game_score.dart`: HUD mục tiêu, lựa chọn tuyến, tiến hóa và kết quả.
- `lib/controller/persistant_game_state.dart`: tiến trình mở khóa sau khi chốt định dạng save và migration.
- `lib/l10n/app_vi.arb`, `lib/l10n/app_en.arb` và các file sinh tự động: toàn bộ nội dung giao diện mới.

## Tiêu chí thành công của bản đầu

- Người chơi mới nêu đúng mục tiêu nhiệm vụ sau phần mở màn.
- Phá mỏ neo làm trận boss dễ hơn theo cách nhìn thấy được.
- Tuyến an toàn và tuyến nguy hiểm đều có tình huống phù hợp để chọn.
- Tiến hóa vũ khí tạo cảm giác mạnh hơn hoặc chơi khác đi ngay trong lượt đó.
- Thắng hoặc thua đều cho người chơi biết bước tiến tiếp theo.
- Chế độ mới không làm hỏng luồng Endless, Boss Rush, phần thưởng hoặc save cũ.

## Quyết định cần giữ

Làm một nhiệm vụ thật sự hoàn chỉnh trước khi mở rộng thành chiến dịch nhiều màn. Nếu bản đầu chưa tạo được mục tiêu rõ ràng, quyết định chiến thuật và cao trào boss, thêm màn mới sẽ chỉ nhân rộng vấn đề hiện tại.
