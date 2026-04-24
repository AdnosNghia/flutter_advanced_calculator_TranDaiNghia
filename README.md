# Lab 3 - Máy Tính Nâng Cao (Advanced Calculator)

## Mô tả dự án

Ứng dụng Máy tính Nâng cao được xây dựng bằng Flutter, hỗ trợ đa chế độ tính toán: Basic (cơ bản), Scientific (khoa học), và Programmer (lập trình viên). Ứng dụng có giao diện hiện đại với hỗ trợ giao diện Sáng/Tối, lưu trữ dữ liệu cục bộ, và các tương tác cử chỉ nâng cao.

### Các tính năng chính

**Chế độ tính toán:**
- Basic: Phép cộng, trừ, nhân, chia, phần trăm, dấu ngoặc
- Scientific: sin, cos, tan, asin, acos, atan, log, ln, sqrt, cbrt, lũy thừa, giai thừa, hằng số pi và e
- Programmer: Chuyển đổi giữa HEX/DEC/OCT/BIN, toán tử bitwise (AND, OR, XOR, NOT, SHL, SHR), nhập số A-F cho hệ 16

**Lưu trữ dữ liệu:**
- Lưu lịch sử tính toán (tối đa 50 phép tính gần nhất, tùy chỉnh 25/50/100)
- Lưu tùy chọn giao diện (Sáng/Tối/Theo hệ thống)
- Lưu chế độ máy tính và hệ cơ số
- Lưu giá trị bộ nhớ (M+, M-, MR, MC)
- Lưu chế độ góc (DEG/RAD)

**Hỗ trợ cử chỉ:**
- Vuốt phải trên màn hình để xóa ký tự cuối
- Nhấn giữ C để xóa lịch sử
- Vuốt lên để mở lịch sử
- Chụm để thay đổi cỡ chữ (0.7x - 1.6x)

**Hoạt ảnh:**
- Hoạt ảnh nhấn nút với hiệu ứng thu nhỏ (200ms)
- Hoạt ảnh chuyển đổi chế độ
- Hiệu ứng mờ dần khi hiển thị kết quả
- Hoạt ảnh rung khi có lỗi (sử dụng TweenSequence)

**Phản hồi:**
- Rung nhẹ khi nhấn nút (Haptic Feedback - bật/tắt trong Settings)
- Âm thanh click khi nhấn nút (Sound Effects - bật/tắt trong Settings)

**Màn hình Cài đặt:**
- Chọn giao diện: Sáng, Tối, Theo hệ thống
- Độ chính xác thập phân: 2-10 chữ số thập phân
- Chế độ góc: Độ (DEG) / Radian (RAD)
- Kích thước lịch sử: 25/50/100
- Xóa toàn bộ lịch sử

---

## Ảnh chụp màn hình


### Chế độ Basic
```
<img width="497" height="1025" alt="{9C10E021-C7C7-4A24-AF88-E9C4B57315CA}" src="https://github.com/user-attachments/assets/f2e83991-906c-4259-9b01-2f5085bf39ac" />

```

### Chế độ Scientific
```
<img width="496" height="1022" alt="{747DC69F-71F4-4275-92E3-05D9C0FDB768}" src="https://github.com/user-attachments/assets/a11b9ad8-32c5-4832-ac23-1cd79b4feaa5" />

```

### Chế độ Programmer (HEX)
```
<img width="503" height="1020" alt="{49A01CCC-C23E-409C-A13D-16818054BAEA}" src="https://github.com/user-attachments/assets/9a0e1011-1eac-4783-a405-c02bcf92d071" />

```

### Màn hình Cài đặt
```
<img width="479" height="1025" alt="{46A93125-A420-414B-80C7-4A5A21549F91}" src="https://github.com/user-attachments/assets/b8b4e699-560a-43a0-bb42-a61414ece59d" />

```

### Màn hình Lịch sử
```
<img width="503" height="1022" alt="{520A7819-496B-4783-AB19-5A63EC94C8F1}" src="https://github.com/user-attachments/assets/b907c22e-27ec-4be8-ad99-3a4972f89e63" />

```

### Giao diện Sáng / Tối
```
<img width="487" height="1014" alt="{A3C0FB74-5DBD-41E2-933E-0249329954F6}" src="https://github.com/user-attachments/assets/bb77abf3-f7c6-445d-9929-d1e9d6c2e7d6" />

<img width="502" height="1022" alt="{C1832E0F-6B83-4280-A017-FB75FB4E12A9}" src="https://github.com/user-attachments/assets/fea0469e-cd7b-4b84-8174-b64b0e95b824" />

```
Link Video : https://drive.google.com/file/d/1lsdH9iBje9jYihAmcFhTJ4QLMDEYKzXU/view?usp=sharing
---

## Sơ đồ kiến trúc

```
lib/
 |-- main.dart                          # Điểm vào ứng dụng, khởi tạo Provider
 |
 |-- models/                            # Lớp dữ liệu
 |   |-- calculator_mode.dart           # Enum: CalculatorMode, AngleMode
 |   |-- calculator_settings.dart       # Model cài đặt (theme, precision, sound...)
 |   |-- calculation_history.dart       # Model lịch sử tính toán (JSON serialize)
 |
 |-- providers/                         # Quản lý trạng thái (ChangeNotifier + Provider)
 |   |-- calculator_provider.dart       # Trạng thái chính: biểu thức, kết quả, bộ nhớ, chế độ
 |   |-- theme_provider.dart            # Quản lý giao diện Sáng/Tối/System
 |   |-- history_provider.dart          # Quản lý lịch sử tính toán
 |
 |-- services/                          # Dịch vụ
 |   |-- storage_service.dart           # Lưu trữ SharedPreferences (history, settings, memory)
 |
 |-- utils/                             # Tiện ích
 |   |-- expression_parser.dart         # Bộ phân tích biểu thức (recursive descent parser)
 |   |-- calculator_logic.dart          # Hàm toán học, chuyển đổi cơ số, định dạng kết quả
 |   |-- constants.dart                 # Hằng số giao diện (màu sắc, kích thước, thời gian)
 |
 |-- screens/                           # Màn hình
 |   |-- calculator_screen.dart         # Màn hình chính của máy tính
 |   |-- settings_screen.dart           # Màn hình cài đặt
 |   |-- history_screen.dart            # Màn hình lịch sử đầy đủ
 |
 |-- widgets/                           # Widget tái sử dụng
 |   |-- display_area.dart              # Vùng hiển thị: biểu thức, kết quả, xem trước lịch sử
 |   |-- button_grid.dart               # Lưới nút: Basic, Scientific, Programmer (A-F, bitwise)
 |   |-- calculator_button.dart         # Widget nút đơn lẻ với hoạt ảnh scale
 |   |-- mode_selector.dart             # Thanh chọn chế độ (Basic/Scientific/Programmer)

test/
 |-- calculator_logic_test.dart         # 75 unit test: toán học, parser, bitwise, chuyển đổi cơ số
 |-- integration_test.dart              # 21 integration test: button sequence, memory, mode switch
 |-- widget_test.dart                   # Widget test placeholder
```

### Luồng dữ liệu

```
[Người dùng nhấn nút]
       |
       v
CalculatorButton (hoạt ảnh scale, haptic, sound)
       |
       v
ButtonGrid (xác định hành động: appendNumber, appendOperator, calculateResult...)
       |
       v
CalculatorProvider (ChangeNotifier)
  |-- Quản lý biểu thức (_expression)
  |-- Gọi ExpressionParser.evaluate()
  |-- Định dạng kết quả (CalculatorLogic.formatResult / toBase)
  |-- Lưu lịch sử (HistoryProvider)
  |-- Lưu bộ nhớ (StorageService)
       |
       v
DisplayArea (hiển thị biểu thức, kết quả, xem trước lịch sử)
```

### Kiến trúc Provider

```
MultiProvider
  |-- CalculatorProvider   # Trạng thái tính toán, bộ nhớ, chế độ, âm thanh
  |-- ThemeProvider        # Giao diện Sáng/Tối/System
  |-- HistoryProvider      # Lịch sử tính toán (tối đa 50 mục)
```

---

## Hướng dẫn cài đặt

### Yêu cầu hệ thống
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio hoặc VS Code với Flutter plugin
- Android Emulator hoặc thiết bị thật (Android/iOS)

### Các bước cài đặt

1. Clone repository:
```bash
git clone <repository-url>
cd lab3_advanced_calculator
```

2. Cài đặt các gói phụ thuộc:
```bash
flutter pub get
```

3. Kiểm tra thiết bị kết nối:
```bash
flutter devices
```

4. Chạy ứng dụng:
```bash
flutter run
```

## Hướng dẫn kiểm thử

### Chạy toàn bộ test
```bash
flutter test
```

### Chạy test theo nhóm
```bash
# Chỉ chạy unit test (calculator logic + expression parser)
flutter test test/calculator_logic_test.dart

# Chỉ chạy integration test (provider + button sequence)
flutter test test/integration_test.dart
```

### Chạy test theo tên
```bash
# Chỉ chạy test bitwise
flutter test --plain-name "Bitwise"

# Chỉ chạy test memory
flutter test --plain-name "Memory"
```


## Hạn chế đã biết

1. **Không hỗ trợ số âm trong Programmer mode**: Các phép toán bitwise chỉ làm việc với số nguyên dương. Số âm có thể cho kết quả không mong muốn do biểu diễn nhị phân bù hai.

2. **Độ chính xác số thập phân**: Sử dụng kiểu `double` của Dart (IEEE 754), nên các phép tính với số thập phân rất lớn hoặc rất nhỏ có thể có sai số làm tròn.

3. **Kích thước số trong Programmer mode**: Không giới hạn kích thước bit (8-bit, 16-bit, 32-bit, 64-bit). Kết quả hiển thị toàn bộ giá trị.

4. **Không hỗ trợ landscape**: Giao diện chỉ được tối ưu cho chế độ dọc (portrait).

5. **Âm thanh nút**: Sử dụng SystemSound.click của hệ thống, không tùy chỉnh được âm thanh riêng.

6. **Không hỗ trợ copy/paste**: Chưa có chức năng sao chép kết quả vào clipboard hoặc dán biểu thức từ clipboard.

---

## Cải tiến trong tương lai

1. **Chế độ Landscape**: Thiết kế giao diện ngang với nhiều nút hơn (mở rộng bàn phím khoa học).

2. **Giới hạn bit trong Programmer mode**: Thêm tùy chọn chọn độ rộng bit (8/16/32/64-bit) để mô phỏng chính xác hơn hành vi overflow.

3. **Copy/Paste**: Hỗ trợ sao chép kết quả và dán biểu thức từ clipboard.

4. **Lịch sử nâng cao**: Tìm kiếm trong lịch sử, lọc theo chế độ, xuất lịch sử ra file.

5. **Widget Calculator**: Tạo widget màn hình chính cho Android để truy cập nhanh.

6. **Hỗ trợ đa ngôn ngữ**: Thêm hỗ trợ tiếng Việt, tiếng Anh, và các ngôn ngữ khác.

7. **Chế độ đồ họa**: Thêm chức năng vẽ đồ thị hàm số (y = f(x)).

8. **Chuyển đổi đơn vị**: Thêm tab chuyển đổi đơn vị (độ dài, khối lượng, nhiệt độ, tiền tệ...).

9. **Âm thanh tùy chỉnh**: Cho phép người dùng chọn âm thanh nút bấm khác nhau.

10. **Xuất/Nhập cài đặt**: Sao lưu và khôi phục cài đặt, lịch sử qua file JSON.

---

## Thông tin tác giả

- **Môn học**: Lập trình Di động Nâng cao
- **Bài thực hành**: Lab 3 - Ứng dụng Máy tính Nâng cao
- **Công nghệ**: Flutter, Dart
- **State Management**: Provider pattern
- **Lưu trữ**: SharedPreferences
