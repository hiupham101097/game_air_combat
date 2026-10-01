// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get useDeviceLanguage => 'Dùng ngôn ngữ thiết bị';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get splashInitializing => 'ĐANG KHỞI TẠO...';

  @override
  String get splashLoadingAssets => 'ĐANG TẢI TÀI NGUYÊN...';

  @override
  String get splashReady => 'SẴN SÀNG CẤT CÁNH';

  @override
  String get lastScore => 'ĐIỂM GẦN NHẤT';

  @override
  String get bestScore => 'ĐIỂM CAO NHẤT';

  @override
  String get upgradeLaser => 'NÂNG CẤP LASER';

  @override
  String get upgradePowerups => 'NÂNG CẤP TRỢ NĂNG';

  @override
  String get inventory => 'KHO ĐỒ';

  @override
  String get quests => 'NHIỆM VỤ';

  @override
  String get leaderboard => 'XẾP HẠNG';

  @override
  String get account => 'TÀI KHOẢN';

  @override
  String get start => 'BẮT ĐẦU';

  @override
  String get eventMode => '⚡ CHẾ ĐỘ SỰ KIỆN';

  @override
  String level(int level) {
    return 'CẤP $level';
  }

  @override
  String powerUpLevel(int level) {
    return 'Cấp $level';
  }

  @override
  String get languageDialogTitle => 'Chọn ngôn ngữ';

  @override
  String get story => 'CỐT TRUYỆN';

  @override
  String get storyTitle => 'CUỘC CHIẾN KHE NỨT';

  @override
  String get storySubtitle => 'Ba bản tin giữa thế giới đang bị vây hãm';

  @override
  String get sectorFrontier => 'VÀNH ĐAI QUỸ ĐẠO';

  @override
  String get sectorRift => 'TIỀN TUYẾN KHE NỨT';

  @override
  String get sectorSiege => 'VÙNG BỊ VÂY HÃM';

  @override
  String get sectorCore => 'LÕI XÂM LƯỢC';

  @override
  String get storyChapterOneTitle => '01 · VẾT RÁCH ĐẦU TIÊN';

  @override
  String get storyChapterOneBody =>
      'Một vết nứt bất khả thi xé toạc không gian phía ngoài các hành tinh. Kẻ thù từ chiều không gian khác tràn vào, tấn công các thuộc địa trước khi lực lượng phòng thủ Trái Đất kịp phản ứng. Những tín hiệu cầu cứu đầu tiên truyền về quê nhà.';

  @override
  String get storyChapterTwoTitle => '02 · HẠM ĐỘI XÂM LƯỢC';

  @override
  String get storyChapterTwoBody =>
      'Kẻ địch quay lại với vũ khí mới và chiến cơ nhanh hơn. Bóng Ma Pha Lệ biến mất giữa các loạt đạn, Oanh Tạc Cơ Khe Nứt cày nát tuyến phòng thủ, Đỉa Khe Nứt săn đội hộ tống và Bầy Mảnh Vỡ tách đôi khi trúng đạn. Mạng lưới lá chắn Trái Đất bắt đầu sụp đổ.';

  @override
  String get storyChapterThreeTitle => '03 · DỰ ÁN CHIẾN CƠ SIÊU HẠNG';

  @override
  String get storyChapterThreeBody =>
      'Các xưởng đóng tàu cuối cùng của nhân loại ghép công nghệ khe nứt thu được vào một chiến cơ mới. Chiến Cơ Siêu Hạng mang Pháo Xuyên Không, dùng chính năng lượng dị không gian của kẻ xâm lược để chống lại chúng. Đạt Cấp 10 để nhận nguyên mẫu, hoặc tích lũy 150.000 xu để mua sớm.';

  @override
  String get storyObjectiveTitle => 'NHIỆM VỤ CỦA BẠN';

  @override
  String get storyObjectiveBody =>
      'Phá vỡ hạm đội xâm lược, tiêu diệt chiến hạm địch và tiến vào khe nứt trước khi đợt tấn công tiếp theo chạm đến Trái Đất.';

  @override
  String get storyBackToHangar => 'TRỞ VỀ NHÀ CHỨA';

  @override
  String get inventoryTitle => 'NHÀ CHỨA & TRANG BỊ';

  @override
  String get chestOpening => 'ĐANG MỞ RƯƠNG...';

  @override
  String get equipped => 'ĐANG DÙNG';

  @override
  String get equip => 'TRANG BỊ';

  @override
  String get coins => 'XU';

  @override
  String get notEnoughCoins => 'Không đủ xu.';

  @override
  String get tabShips => 'CHIẾN CƠ';

  @override
  String get tabWeapons => 'VŨ KHÍ';

  @override
  String get tabEquipment => 'TRANG BỊ';

  @override
  String get warehouse => 'KHO ĐỒ';

  @override
  String get upgrade => 'NÂNG CẤP';

  @override
  String get openOne => 'MỞ x1 · 1.000';

  @override
  String get openTen => 'MỞ x10 · 10.000';

  @override
  String legendaryGuarantee(int count) {
    return 'BẢO ĐẢM HUYỀN THOẠI: $count/80';
  }

  @override
  String location(Object slot) {
    return 'VỊ TRÍ: $slot';
  }

  @override
  String get unequip => 'THÁO';

  @override
  String get openChest => 'MỞ RƯƠNG';

  @override
  String gachaNeedCoins(int amount) {
    return 'Cần $amount xu để mở rương.';
  }

  @override
  String get gachaResult => '✨ KẾT QUẢ MỞ RƯƠNG ✨';

  @override
  String get equipmentReceived => 'TRANG BỊ MỚI NHẬN ĐƯỢC';

  @override
  String get great => 'TUYỆT VỜI!';

  @override
  String get energyStones => 'Đá năng lượng';

  @override
  String get energyCores => 'Lõi năng lượng';

  @override
  String duplicatesConverted(int count) {
    return 'Đã đổi $count vật phẩm trùng';
  }

  @override
  String get noEquipment => 'Bạn chưa sở hữu trang bị nào.';

  @override
  String get upgradeUnlockRequirement =>
      'Cần trang bị 4 món đạt cấp 9 để mở nâng cấp này.';

  @override
  String get maxLevelReached => 'Đã đạt cấp tối đa: 100';

  @override
  String levelChange(int current, int next) {
    return 'Cấp $current ➜ $next';
  }

  @override
  String upgradeSuccess(Object item, int level) {
    return 'Đã nâng $item lên cấp $level!';
  }

  @override
  String purchaseSuccess(Object item) {
    return 'Đã mua $item!';
  }

  @override
  String energyStonesGained(int amount) {
    return '+$amount đá năng lượng';
  }

  @override
  String energyCoresGained(int amount) {
    return '+$amount lõi năng lượng';
  }

  @override
  String get rarityCommon => 'THƯỜNG';

  @override
  String get rarityRare => 'HIẾM';

  @override
  String get rarityEpic => 'SỬ THI';

  @override
  String get rarityLegendary => 'HUYỀN THOẠI';

  @override
  String get slotCore => 'LÕI';

  @override
  String get slotArmor => 'GIÁP';

  @override
  String get slotEngine => 'ĐỘNG CƠ';

  @override
  String get slotDrone => 'DRONE';

  @override
  String get daily => 'HẰNG NGÀY';

  @override
  String get weekly => 'HẰNG TUẦN';

  @override
  String get questsTitle => 'NHIỆM VỤ NGÀY & TUẦN';

  @override
  String coinsCount(int count) {
    return 'Xu: $count';
  }

  @override
  String get claimed => 'ĐÃ NHẬN';

  @override
  String claimReward(int count) {
    return 'NHẬN $count XU';
  }

  @override
  String rewardCoins(int count) {
    return 'THƯỞNG: $count XU';
  }

  @override
  String questPlayGames(int count) {
    return 'Chơi $count trận';
  }

  @override
  String questKillEnemies(int count) {
    return 'Tiêu diệt $count kẻ địch';
  }

  @override
  String questCollectCoins(int count) {
    return 'Thu thập $count xu';
  }

  @override
  String get leaderboardTitle => 'BẢNG XẾP HẠNG';

  @override
  String get loginTitle => 'TÀI KHOẢN LƯU ĐÁM MÂY';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get signIn => 'ĐĂNG NHẬP';

  @override
  String get register => 'TẠO TÀI KHOẢN';

  @override
  String get cancel => 'HỦY';

  @override
  String get loginFailed =>
      'Đăng nhập thất bại. Hãy kiểm tra thông tin rồi thử lại.';

  @override
  String get registerFailed =>
      'Tạo tài khoản thất bại. Hãy kiểm tra thông tin rồi thử lại.';

  @override
  String get pauseTitle => 'TẠM DỪNG';

  @override
  String get resume => 'TIẾP TỤC';

  @override
  String get powerBoost => 'TĂNG SỨC MẠNH';

  @override
  String get loading => 'ĐANG TẢI...';

  @override
  String get quit => 'THOÁT';

  @override
  String get quitTitle => 'Thoát trận đấu?';

  @override
  String get quitWarning => 'Trận đấu sẽ kết thúc và điểm số không được lưu.';

  @override
  String get revive => 'HỒI SINH';

  @override
  String get reviveDescription =>
      'Xem quảng cáo để hồi sinh và tiếp tục trận đấu.';

  @override
  String get watchAd => 'XEM QUẢNG CÁO';

  @override
  String get home => 'VỀ TRANG CHỦ';

  @override
  String get bossDefeated => 'ĐÃ ĐÁNH BẠI BOSS!';

  @override
  String get chooseBuff => 'CHỌN CƯỜNG HÓA';

  @override
  String runLevelShort(int level) {
    return 'CẤP $level';
  }

  @override
  String runUpgradeTitle(int level) {
    return 'CẤP CHIẾN ĐẤU $level';
  }

  @override
  String get runUpgradeSubtitle => 'CHỌN MỘT GIAO THỨC TÁC CHIẾN';

  @override
  String get runUpgradeDamageName => 'LÕI QUÁ TẢI';

  @override
  String get runUpgradeDamageDescription =>
      '+10% sát thương vũ khí trong trận này';

  @override
  String get runUpgradeFireName => 'CHU KỲ TĂNG TỐC';

  @override
  String get runUpgradeFireDescription => '+8% tốc độ bắn trong trận này';

  @override
  String get runUpgradeMultiName => 'NÒNG TÁCH ĐẠN';

  @override
  String get runUpgradeMultiDescription => '+1 viên đạn phụ mỗi loạt';

  @override
  String get runUpgradeCriticalName => 'MA TRẬN NGẮM BẮN';

  @override
  String get runUpgradeCriticalDescription => '+5% tỷ lệ chí mạng';

  @override
  String get runUpgradeThrusterName => 'ĐỘNG CƠ ĐỔI HƯỚNG';

  @override
  String get runUpgradeThrusterDescription => '+10% tốc độ di chuyển';

  @override
  String get runUpgradeHullName => 'VỎ GIÁP GIA CƯỜNG';

  @override
  String get runUpgradeHullDescription => '+1 máu tối đa và hồi 1 máu';

  @override
  String get runUpgradeRepairName => 'NANITE SỬA CHỮA';

  @override
  String get runUpgradeRepairDescription => 'Hồi 1 máu';

  @override
  String get runUpgradeRiftName => 'TỤ ĐIỆN KHE NỨT';

  @override
  String get runUpgradeRiftDescription => 'Nạp thêm 25 năng lượng Bùng Nổ';

  @override
  String get runUpgradeShieldName => 'KHIÊN PHA';

  @override
  String get runUpgradeShieldDescription =>
      'Kích hoạt khiên năng lượng trong 1,5 giây';

  @override
  String get damageBuffTitle => 'TĂNG SÁT THƯƠNG';

  @override
  String get fireRateBuffTitle => 'TĂNG TỐC ĐỘ BẮN';

  @override
  String get rareDamageBuffTitle => 'TĂNG SÁT THƯƠNG HIẾM';

  @override
  String damageBuff(int percent) {
    return '+$percent% sát thương vũ khí';
  }

  @override
  String fireRateBuff(int percent) {
    return '+$percent% tốc độ bắn';
  }

  @override
  String comboLabel(int count) {
    return 'COMBO x$count';
  }

  @override
  String scoreMultiplier(Object multiplier) {
    return 'ĐIỂM x$multiplier';
  }

  @override
  String nearMissBonus(int score) {
    return 'NÉ SÁT  +$score';
  }

  @override
  String get riftBurst => 'BÙNG NỔ KHE NỨT';

  @override
  String get riftBurstReady => 'ĐÃ SẴN SÀNG';

  @override
  String get phaseShift => 'DỊCH CHUYỂN PHA';

  @override
  String get phaseShiftReady => 'SẴN SÀNG LƯỚT';

  @override
  String equipmentResonance(Object rarity, int count) {
    return 'CỘNG HƯỞNG $rarity: $count/4';
  }

  @override
  String get equipmentResonanceBonuses =>
      '2 món: +5% tốc độ bắn · 3: +8% sát thương · 4: +1 máu, +5% tốc độ';

  @override
  String get equipmentResonanceNone =>
      'Trang bị các món cùng phẩm chất để mở cộng hưởng.';

  @override
  String get shipStandard => 'Đánh Chặn';

  @override
  String get shipStandardDescription =>
      'Chiến cơ cân bằng, bền bỉ, phù hợp mọi tình huống.';

  @override
  String get shipRacer => 'Tốc Độ';

  @override
  String get shipRacerDescription =>
      'Chiến cơ linh hoạt, tăng 20% tốc độ di chuyển.';

  @override
  String get shipPhoenix => 'Phượng Hoàng';

  @override
  String get shipPhoenixDescription =>
      'Chiến cơ hỏa lực mạnh, tăng 30% tốc độ bắn.';

  @override
  String get shipStealth => 'Tàng Hình';

  @override
  String get shipStealthDescription =>
      'Chiến cơ nhanh nhẹn, có vùng va chạm nhỏ hơn.';

  @override
  String get shipGuardian => 'Hộ Vệ';

  @override
  String get shipGuardianDescription =>
      'Chiến hạm hạng nặng, tăng 50% tốc độ bắn và có khiên bền hơn.';

  @override
  String get shipSuperFighter => 'Chiến Cơ Siêu Hạng';

  @override
  String get shipSuperFighterDescription =>
      'Nguyên mẫu tối tân dùng năng lượng khe nứt và Pháo Xuyên Không.';

  @override
  String get shipRiftDancer => 'Vũ Điệu Khe Nứt';

  @override
  String get shipRiftDancerDescription =>
      'Chiến cơ nhanh nhẹn, đạn hồ quang cong quét ngang đội hình địch.';

  @override
  String get shipBastion => 'Pháo Đài';

  @override
  String get shipBastionDescription =>
      'Chiến hạm hạng nặng rải đạn pháo trên một vùng rộng.';

  @override
  String get weaponBasic => 'Laser Tiêu Chuẩn';

  @override
  String get weaponBasicDescription => 'Tia laser bắn nhanh, đáng tin cậy.';

  @override
  String get weaponSpread => 'Pháo Chùm';

  @override
  String get weaponSpreadDescription => 'Bắn ba viên đạn theo hình quạt rộng.';

  @override
  String get weaponPiercing => 'Tia Xuyên Phá';

  @override
  String get weaponPiercingDescription =>
      'Tia năng lượng mạnh xuyên qua kẻ địch.';

  @override
  String get weaponHoming => 'Tên Lửa Tự Dẫn';

  @override
  String get weaponHomingDescription => 'Tên lửa tự tìm mục tiêu gần nhất.';

  @override
  String get weaponRapid => 'Pháo Xung Kích';

  @override
  String get weaponRapidDescription => 'Bắn liên tục các loạt plasma nhẹ.';

  @override
  String get weaponPlasma => 'Pháo Plasma';

  @override
  String get weaponPlasmaDescription =>
      'Bắn đạn plasma lớn, gây sát thương cao.';

  @override
  String get weaponNova => 'Sóng Nova';

  @override
  String get weaponNovaDescription => 'Phóng sóng năng lượng rộng để mở đường.';

  @override
  String get weaponPhase => 'Pháo Xuyên Không';

  @override
  String get weaponPhaseDescription =>
      'Tia năng lượng pha tập trung, xé xuyên giáp kẻ địch.';

  @override
  String get weaponArc => 'Pháo Hồ Quang Khe Nứt';

  @override
  String get weaponArcDescription =>
      'Bắn ba luồng năng lượng cong quét ngang đội hình địch.';

  @override
  String get weaponFlak => 'Pháo Phòng Vây';

  @override
  String get weaponFlakDescription =>
      'Rải một loạt đạn nổ trên vùng quạt rộng.';

  @override
  String get eqCore1Name => 'Lõi Phản Ứng Thường';

  @override
  String get eqCore1Description => 'Tăng 10% sát thương vũ khí';

  @override
  String get eqCore2Name => 'Lõi Plasma Xanh';

  @override
  String get eqCore2Description =>
      'Tăng 25% sát thương vũ khí và 5% tỷ lệ chí mạng';

  @override
  String get eqCore3Name => 'Lõi Năng Lượng Tối';

  @override
  String get eqCore3Description => 'Tăng 50% sát thương vũ khí';

  @override
  String get eqCore4Name => 'Lõi Lượng Tử Hủy Diệt';

  @override
  String get eqCore4Description => 'Tăng 100% sát thương vũ khí';

  @override
  String get eqArmor1Name => 'Giáp Sắt Cơ Bản';

  @override
  String get eqArmor1Description => '+1 máu; chặn một đòn đánh mỗi 20 giây';

  @override
  String get eqArmor2Name => 'Giáp Titan';

  @override
  String get eqArmor2Description =>
      '+2 máu, giảm 14% sát thương, giảm 10% tốc độ di chuyển';

  @override
  String get eqArmor3Name => 'Giáp Năng Lượng Động';

  @override
  String get eqArmor3Description =>
      '+3 máu, giảm 20% sát thương; tạo khiên 1,5 giây sau 5 giây không trúng đòn';

  @override
  String get eqArmor4Name => 'Giáp Bất Tử';

  @override
  String get eqArmor4Description =>
      '+5 máu, giảm 26% sát thương; tăng 35% sát thương khi máu dưới 30%';

  @override
  String get eqEngine1Name => 'Động Cơ Ion Phụ';

  @override
  String get eqEngine1Description => 'Tăng 10% tốc độ bay';

  @override
  String get eqEngine2Name => 'Động Cơ Siêu Tốc';

  @override
  String get eqEngine2Description => 'Tăng 20% tốc độ bay';

  @override
  String get eqEngine3Name => 'Bước Nhảy Không Gian';

  @override
  String get eqEngine3Description => '+40% tốc độ bay và +10% tốc độ nạp Rift';

  @override
  String get eqDrone1Name => 'Drone Bắn Tỉa Nhỏ';

  @override
  String get eqDrone1Description => 'Trợ thủ bắn 1 phát mỗi giây.';

  @override
  String get eqDrone2Name => 'Drone Hủy Diệt';

  @override
  String get eqDrone2Description => 'Trợ thủ bắn 3 phát mỗi giây.';

  @override
  String get eqDrone3Name => 'Mắt Thần Theo Dõi';

  @override
  String get eqDrone3Description => 'Bắn 5 đạn tự dẫn mỗi giây.';

  @override
  String get powerShield => 'Khiên';

  @override
  String get powerSideLaser => 'Laser bên';

  @override
  String get powerSpeedBoost => 'Tăng tốc';

  @override
  String get powerRapidFire => 'Tăng tốc độ bắn';

  @override
  String firingStyle(Object weapon) {
    return 'VŨ KHÍ: $weapon';
  }

  @override
  String speedMultiplier(Object multiplier) {
    return 'TỐC ĐỘ ×$multiplier';
  }

  @override
  String damageMultiplier(Object multiplier) {
    return 'SÁT THƯƠNG ×$multiplier';
  }

  @override
  String get eqDrone4Name => 'Drone Hộ Vệ';

  @override
  String get eqDrone4Description =>
      'Tạo khiên cho chiến cơ trong 1,5 giây mỗi 15 giây';

  @override
  String get eqDrone5Name => 'Drone Sửa Chữa';

  @override
  String get eqDrone5Description => 'Hồi một điểm máu mỗi 30 giây';

  @override
  String get combatStats => 'CHỈ SỐ CHIẾN ĐẤU';

  @override
  String get statHp => 'MÁU';

  @override
  String get statArmor => 'GIÁP';

  @override
  String get statDamage => 'SÁT THƯƠNG';

  @override
  String get statFireRate => 'TỐC BẮN';

  @override
  String get statCrit => 'CHÍ MẠNG';

  @override
  String get statProjectile => 'LOẠT ĐẠN';

  @override
  String get statDrone => 'DRONE';

  @override
  String get statSkillCharge => 'NẠP KỸ NĂNG';

  @override
  String get statMovement => 'DI CHUYỂN';

  @override
  String get droneRoleNone => 'Không có';

  @override
  String get droneRoleAttack => 'Tấn công';

  @override
  String get droneRoleShield => 'Hộ vệ';

  @override
  String get droneRoleRepair => 'Sửa chữa';

  @override
  String get droneRoleMissile => 'Tên lửa';

  @override
  String get droneRoleLaser => 'Laser';

  @override
  String get criticalHit => 'CHÍ MẠNG!';

  @override
  String get statCritDamage => 'SÁT THƯƠNG CM';

  @override
  String get statProjectileSpeed => 'TỐC ĐẠN';

  @override
  String get statPierce => 'XUYÊN';

  @override
  String get statPierceAll => 'TẤT CẢ';

  @override
  String get statBlast => 'BÁN KÍNH NỔ';

  @override
  String get statSkillCooldown => 'HỒI KỸ NĂNG';

  @override
  String get statShield => 'KHIÊN';

  @override
  String get statReady => 'SẴN SÀNG';

  @override
  String get statOff => 'TẪeT';
}
