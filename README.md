# chikawa_airport

你好，這是一個專案

## 前置

因為一些原因，Android模擬器的版本有些不對
所以接下來請跟我一起做

### 1. SDK設定 
因為flutter目前推薦用android15、API35來進行，所以到設定的Android SDK進行設定
- 選擇SDK Platforms，勾選右下角Show Package Details
- 展開Android 15，勾選以下安裝(如果怕儲存空間不夠可以將Android 16取消勾選)
	1. Android SDK Platform 35
	2. Sources for Android 35
	3. Google Play Intel x86_64 Atom System Image
- 完成後移動到SDK Tools安裝以下版本
	1. Android SDK Build Tools 34.0.0
	2. NDK(Side by Side) 26.3.11579264
	3. Android SDK Command-line Tools(latest) 19.0
	4. CMake 3.22.1
### 2. 模擬器
回到首頁，點擊在New Project / Open / Clone Repository底下的More Actions。
選擇Virtual Device Manager，新建一個模擬器，設定如下
	1. 隨便選一個機型
	2. API選擇API 35 , Android 15.0
	3. 選擇Google Play Intel x86_64 Atom System Image後完成

好耶，這樣應該就能在模擬器開啟app了，反正我是可以