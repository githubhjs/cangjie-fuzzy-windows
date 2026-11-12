# cangjie-fuzzy-windows

**Windows 11（小狼毫 Weasel）：倉頡（三代為預設，五代可選）＋相鄰鍵容錯，容錯方案就是預設方案。**
**Windows 11 (Weasel): Cangjie (3rd generation by default, 5th optional) with adjacent-key typo tolerance as the DEFAULT schema.**

---

## 繁體中文

打字時按錯**一個相鄰的按鍵**也沒關係：例如想打「顏」(`yhmbc`) 卻打成 `yhmbv`，「顏」照樣會出現在候選裡；正確的候選永遠排在最前面。安裝完直接就是這個方案，**不必按 Ctrl+` 或 F4 切換**。

這個專案內含完整的 cj*fluency：倉頡三代／五代碼表、詞表、語言模型都在 release 裡，**不依賴任何第三方**。同一份內容也單獨發布成 [githubhjs/cangjie-fluency](https://github.com/githubhjs/cangjie-fluency)，那裡的預設方案是普通的 cangjie3_fluency（容錯方案排第二）。

### 一行安裝

```powershell
irm https://raw.githubusercontent.com/githubhjs/cangjie-fuzzy-windows/main/install.ps1 | iex
```

加選項（例如五代、較寬的容錯範圍）：

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/githubhjs/cangjie-fuzzy-windows/main/install.ps1))) -Cangjie5 -FuzzyRange wide
```

選項：`-Cangjie5` 也裝五代（同樣有容錯版）· `-FuzzyRange narrow|normal|wide` 範圍 · `-NoDeploy` 不部署 · `-NoModel` 不裝語言模型 · `-NoSweep` 不安裝滑行面板 · `-PadRef <tag>` 滑行面板版本 · `-Offline` 只用隨附檔案 · `-DryRun` 只顯示會做什麼 · `-SkipWeaselInstall`

隨附「倉頡滑行輸入面板」（Cangjie Sweep Pad）：預設會一併安裝至 `%LOCALAPPDATA%\cangjie-sweep`，並在「開始」功能表建立「Cangjie Sweep 倉頡滑行」捷徑與 `cangjie-sweep.bat` 啟動檔。需要 Python 3.8+ 及 tkinter（`winget install Python.Python.3.12`）；若未安裝 Python，基礎方案安裝仍會成功。注意：在目標應用程式中輸入時，小狼毫（Weasel）必須是作用中的輸入法。可用 `-NoSweep` 略過安裝。

離線：下載 release 的 `-full.zip`，解開後執行 `install.bat`（需要時加參數，例如 `install.bat -Cangjie5`）。

### 預設值與可調整

容錯範圍（兩個鍵的中心距離不超過幾個鍵寬算相鄰）：`narrow` = 只有左右相鄰；`normal`（預設）= 再加斜向相鄰；`wide` = 再多一圈。每碼最多容錯 1 個鍵；每句上限為碼數的 40%（至少 2）僅在我們自己的比對器（Android、程式庫）生效，桌面 Rime 只有每碼容錯。預設值的研究依據：[DEFAULTS.md](https://github.com/githubhjs/cangjie-fuzzy-core/blob/main/DEFAULTS.md)。

### 已驗證 / 未驗證

已驗證：
- 引擎層（用 Weasel 自己的 `rime.dll`，Windows PowerShell 5.1 跑真正的安裝程式）：20 項檢查全過（見下方測試）。
- 基礎安裝程式（cangjie-fluency）的 pwsh 情境測試 16 項全過。

**沒有驗證**：
- 在小狼毫的輸入視窗裡實際打字（只測到引擎，沒有操作 GUI）。
- 全新電腦上的靜默安裝小狼毫（`/S` 加 UAC）。

### 測試

`tests/headless/run_matrix.sh（在 cangjie-fuzzy-core 倉庫）` 會安裝真正的 release 包，再用各平台自己的 librime 無介面地檢查 20 項（含：正確的候選仍排第一、相鄰鍵打錯能找回、兩個位置都錯或不相鄰則不會、方案清單第一個是容錯方案）。

### 授權

本專案自己的檔案為 MIT。隨附的碼表、詞表與語言模型是 LGPL-3.0 的資料，原樣放入，授權文字隨基礎專案附上；詳見 githubhjs/cangjie-fluency。

---

## English

One wrong key is fine **when it is a physical neighbour**: type `yhmbv` instead of `yhmbc` and 顏 is still offered; the exact candidates always come first. After the install this is simply the default schema, **no Ctrl+` or F4 needed**.

The project contains the full cj*fluency (3rd and 5th generation tables, word list, language model) in its release, with **no third-party dependency**. The same content is also published as [githubhjs/cangjie-fluency](https://github.com/githubhjs/cangjie-fluency), where the default is plain cangjie3_fluency (the typo-tolerant schema is listed second).

### One-line install

```powershell
irm https://raw.githubusercontent.com/githubhjs/cangjie-fuzzy-windows/main/install.ps1 | iex
```

With options (for example 5th generation, a wider tolerance range):

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/githubhjs/cangjie-fuzzy-windows/main/install.ps1))) -Cangjie5 -FuzzyRange wide
```

Options: `-Cangjie5` also install 5th generation (with its typo-tolerant version) · `-FuzzyRange narrow|normal|wide` range · `-NoDeploy` · `-NoModel` skip the language model · `-NoSweep` skip the Sweep Pad · `-PadRef <tag>` Sweep Pad release tag · `-Offline` bundle files only · `-DryRun` · `-SkipWeaselInstall`

Includes the "Cangjie Sweep Pad" (mouse/touch glide typing): installed by default to `%LOCALAPPDATA%\cangjie-sweep` with a Start Menu shortcut "Cangjie Sweep 倉頡滑行" and a `cangjie-sweep.bat` launcher. Requires Python 3.8+ with tkinter (`winget install Python.Python.3.12`); if Python is missing, the Rime schema installation still succeeds. Note: Weasel must be the active IME in the target application. Pass `-NoSweep` to skip installing the pad.

Offline: download the release `-full.zip`, unpack it and run `install.bat` (add options if needed, e.g. `install.bat -Cangjie5`).

### Defaults and what you can change

Range (how far apart two key centres may be to count as neighbours): `narrow` = left/right only; `normal` (default) = plus diagonals; `wide` = one more ring. One wrong key per code. The per-phrase limit (40% of the codes, at least 2) only applies in our own matcher (Android, the library); desktop Rime has the per-code tolerance only. Evidence for the defaults: [DEFAULTS.md](https://github.com/githubhjs/cangjie-fuzzy-core/blob/main/DEFAULTS.md).

### Verified / not verified

Verified:
- Engine level (Weasel's own `rime.dll`, the real installer under Windows PowerShell 5.1): all 20 checks pass (see Tests).
- The base installer's pwsh scenario tests: 16 of 16 pass.

**Not verified**:
- Typing in Weasel's real input window (the engine is tested, not the GUI).
- Silent Weasel install on a clean PC (`/S` plus UAC).

### Tests

`tests/headless/run_matrix.sh（在 cangjie-fuzzy-core 倉庫）` installs the real release bundle and checks 20 things headlessly with each platform's own librime (exact candidates still first, one adjacent wrong key is recovered, two wrong keys or a non-adjacent key is not, the first schema in the list is the typo-tolerant one).

### Licence

Our own files are MIT. The bundled tables, word list and language model are LGPL-3.0 data, shipped unchanged with the licence texts in the base project; see githubhjs/cangjie-fluency.

## Changelog / 更新紀錄

- **v0.2.2** — Sweep Pad v0.4.0: single-character backtrack slips decode correctly (decode_auto), word floor 1000. / 滑行輸入板 v0.4.0：單字回頭滑行也能正確解碼（decode_auto），詞頻下限 1000。
- **v0.2.1** — Sweep Pad v0.3.0: tolerance for backtracks. / 滑行輸入板 v0.3.0：容許回頭滑行。
- **v0.2.0** — Sweep Pad added (base cangjie-fluency v0.6.0); default on, `-NoSweep` to skip. / 新增倉頡滑行輸入板（基礎安裝程式 cangjie-fluency v0.6.0）；預設安裝，加 `-NoSweep` 可略過。
