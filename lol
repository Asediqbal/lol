 # Momentum:

//@version=5
indicator(title="Momentum", shorttitle="Mom", timeframe="", timeframe_gaps=true)
len = input.int(10, minval=1, title="Length")
src = input(close, title="Source")
mom = src - src[len]
plot(mom, color=#2962FF, title="MOM")

 # Moving Average Ribbon

//@version=5
indicator("Moving Average Ribbon", shorttitle="MA Ribbon", overlay=true, timeframe="", timeframe_gaps=true)

ma(source, length, type) =>
    type == "SMA" ? ta.sma(source, length) :
     type == "EMA" ? ta.ema(source, length) :
     type == "SMMA (RMA)" ? ta.rma(source, length) :
     type == "WMA" ? ta.wma(source, length) :
     type == "VWMA" ? ta.vwma(source, length) :
     na

show_ma1   = input(true   , "MA №1", inline="MA #1")
ma1_type   = input.string("SMA"  , ""     , inline="MA #1", options=["SMA", "EMA", "SMMA (RMA)", "WMA", "VWMA"])
ma1_source = input(close  , ""     , inline="MA #1")
ma1_length = input.int(20     , ""     , inline="MA #1", minval=1)
ma1_color  = input(#f6c309, ""     , inline="MA #1")
ma1 = ma(ma1_source, ma1_length, ma1_type)
plot(show_ma1 ? ma1 : na, color = ma1_color, title="MA №1")

show_ma2   = input(true   , "MA №2", inline="MA #2")
ma2_type   = input.string("SMA"  , ""     , inline="MA #2", options=["SMA", "EMA", "SMMA (RMA)", "WMA", "VWMA"])
ma2_source = input(close  , ""     , inline="MA #2")
ma2_length = input.int(50     , ""     , inline="MA #2", minval=1)
ma2_color  = input(#fb9800, ""     , inline="MA #2")
ma2 = ma(ma2_source, ma2_length, ma2_type)
plot(show_ma2 ? ma2 : na, color = ma2_color, title="MA №2")

show_ma3   = input(true   , "MA №3", inline="MA #3")
ma3_type   = input.string("SMA"  , ""     , inline="MA #3", options=["SMA", "EMA", "SMMA (RMA)", "WMA", "VWMA"])
ma3_source = input(close  , ""     , inline="MA #3")
ma3_length = input.int(100    , ""     , inline="MA #3", minval=1)
ma3_color  = input(#fb6500, ""     , inline="MA #3")
ma3 = ma(ma3_source, ma3_length, ma3_type)
plot(show_ma3 ? ma3 : na, color = ma3_color, title="MA №3")

show_ma4   = input(true   , "MA №4", inline="MA #4")
ma4_type   = input.string("SMA"  , ""     , inline="MA #4", options=["SMA", "EMA", "SMMA (RMA)", "WMA", "VWMA"])
ma4_source = input(close  , ""     , inline="MA #4")
ma4_length = input.int(200    , ""     , inline="MA #4", minval=1)
ma4_color  = input(#f60c0c, ""     , inline="MA #4")
ma4 = ma(ma4_source, ma4_length, ma4_type)
plot(show_ma4 ? ma4 : na, color = ma4_color, title="MA №4")


 # Candlestick pattern

//@version=5
indicator("*All Candlestick Patterns*", shorttitle = "All Patterns", overlay=true)

C_DownTrend = true
C_UpTrend = true
var trendRule1 = "SMA50"
var trendRule2 = "SMA50, SMA200"
var trendRule = input.string(trendRule1, "Detect Trend Based On", options=[trendRule1, trendRule2, "No detection"])

if trendRule == trendRule1
	priceAvg = ta.sma(close, 50)
	C_DownTrend := close < priceAvg
	C_UpTrend := close > priceAvg

if trendRule == trendRule2
	sma200 = ta.sma(close, 200)
	sma50 = ta.sma(close, 50)
	C_DownTrend := close < sma50 and sma50 < sma200
	C_UpTrend := close > sma50 and sma50 > sma200
C_Len = 14 // ta.ema depth for bodyAvg
C_ShadowPercent = 5.0 // size of shadows
C_ShadowEqualsPercent = 100.0
C_DojiBodyPercent = 5.0
C_Factor = 2.0 // shows the number of times the shadow dominates the candlestick body

C_BodyHi = math.max(close, open)
C_BodyLo = math.min(close, open)
C_Body = C_BodyHi - C_BodyLo
C_BodyAvg = ta.ema(C_Body, C_Len)
C_SmallBody = C_Body < C_BodyAvg
C_LongBody = C_Body > C_BodyAvg
C_UpShadow = high - C_BodyHi
C_DnShadow = C_BodyLo - low
C_HasUpShadow = C_UpShadow > C_ShadowPercent / 100 * C_Body
C_HasDnShadow = C_DnShadow > C_ShadowPercent / 100 * C_Body
C_WhiteBody = open < close
C_BlackBody = open > close
C_Range = high-low
C_IsInsideBar = C_BodyHi[1] > C_BodyHi and C_BodyLo[1] < C_BodyLo
C_BodyMiddle = C_Body / 2 + C_BodyLo
C_ShadowEquals = C_UpShadow == C_DnShadow or (math.abs(C_UpShadow - C_DnShadow) / C_DnShadow * 100) < C_ShadowEqualsPercent and (math.abs(C_DnShadow - C_UpShadow) / C_UpShadow * 100) < C_ShadowEqualsPercent
C_IsDojiBody = C_Range > 0 and C_Body <= C_Range * C_DojiBodyPercent / 100
C_Doji = C_IsDojiBody and C_ShadowEquals

patternLabelPosLow = low - (ta.atr(30) * 0.6)
patternLabelPosHigh = high + (ta.atr(30) * 0.6)

label_color_bullish = input(color.blue, "Label Color Bullish")
label_color_bearish = input(color.red, "Label Color Bearish")
label_color_neutral = input(color.gray, "Label Color Neutral")
CandleType = input.string(title = "Pattern Type", defval="Both", options=["Bullish", "Bearish", "Both"])

AbandonedBabyInput = input(title = "Abandoned Baby" ,defval=true)

DarkCloudCoverInput = input(title = "Dark Cloud Cover" ,defval=false)

DojiInput = input(title = "Doji" ,defval=true)

DojiStarInput = input(title = "Doji Star" ,defval=false)

DownsideTasukiGapInput = input(title = "Downside Tasuki Gap" ,defval=false)

DragonflyDojiInput = input(title = "Dragonfly Doji" ,defval=true)

EngulfingInput = input(title = "Engulfing" ,defval=true)

EveningDojiStarInput = input(title = "Evening Doji Star" ,defval=false)

EveningStarInput = input(title = "Evening Star" ,defval=false)

FallingThreeMethodsInput = input(title = "Falling Three Methods" ,defval=false)

FallingWindowInput = input(title = "Falling Window" ,defval=false)

GravestoneDojiInput = input(title = "Gravestone Doji" ,defval=false)

HammerInput = input(title = "Hammer" ,defval=true)

HangingManInput = input(title = "Hanging Man" ,defval=false)

HaramiCrossInput = input(title = "Harami Cross" ,defval=false)

HaramiInput = input(title = "Harami" ,defval=false)

InvertedHammerInput = input(title = "Inverted Hammer" ,defval=false)

KickingInput = input(title = "Kicking" ,defval=false)

LongLowerShadowInput = input(title = "Long Lower Shadow" ,defval=false)

LongUpperShadowInput = input(title = "Long Upper Shadow" ,defval=false)

MarubozuBlackInput = input(title = "Marubozu Black" ,defval=false)

MarubozuWhiteInput = input(title = "Marubozu White" ,defval=false)

MorningDojiStarInput = input(title = "Morning Doji Star" ,defval=false)

MorningStarInput = input(title = "Morning Star" ,defval=false)

OnNeckInput = input(title = "On Neck" ,defval=false)

PiercingInput = input(title = "Piercing" ,defval=false)

RisingThreeMethodsInput = input(title = "Rising Three Methods" ,defval=false)

RisingWindowInput = input(title = "Rising Window" ,defval=false)

ShootingStarInput = input(title = "Shooting Star" ,defval=false)

SpinningTopBlackInput = input(title = "Spinning Top Black" ,defval=false)

SpinningTopWhiteInput = input(title = "Spinning Top White" ,defval=false)

ThreeBlackCrowsInput = input(title = "Three Black Crows" ,defval=false)

ThreeWhiteSoldiersInput = input(title = "Three White Soldiers" ,defval=false)

TriStarInput = input(title = "Tri-Star" ,defval=false)

TweezerBottomInput = input(title = "Tweezer Bottom" ,defval=false)

TweezerTopInput = input(title = "Tweezer Top" ,defval=false)

UpsideTasukiGapInput = input(title = "Upside Tasuki Gap" ,defval=false)

C_OnNeckBearishNumberOfCandles = 2
C_OnNeckBearish = false
if C_DownTrend and C_BlackBody[1] and C_LongBody[1] and C_WhiteBody and open < close[1] and C_SmallBody and C_Range!=0 and math.abs(close-low[1])<=C_BodyAvg*0.05
	C_OnNeckBearish := true
alertcondition(C_OnNeckBearish, title = "On Neck – Bearish", message = "New On Neck – Bearish pattern detected")
if C_OnNeckBearish  and  OnNeckInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishOnNeck = "On Neck\nOn Neck is a two-line continuation pattern found in a downtrend. The first candle is long and red, the second candle is short and has a green body. The closing price of the second candle is close or equal to the first candle's low price. The pattern hints at a continuation of a downtrend, and penetrating the low of the green candlestick is sometimes considered a confirmation. "
    label.new(bar_index, patternLabelPosHigh, text="ON", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishOnNeck)
C_RisingWindowBullishNumberOfCandles = 2
C_RisingWindowBullish = false
if C_UpTrend[1] and (C_Range!=0 and C_Range[1]!=0) and low > high[1]
	C_RisingWindowBullish := true
alertcondition(C_RisingWindowBullish, title = "Rising Window – Bullish", message = "New Rising Window – Bullish pattern detected")
if C_RisingWindowBullish  and  RisingWindowInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishRisingWindow = "Rising Window\nRising Window is a two-candle bullish continuation pattern that forms during an uptrend. Both candles in the pattern can be of any type with the exception of the Four-Price Doji. The most important characteristic of the pattern is a price gap between the first candle's high and the second candle's low. That gap (window) between two bars signifies support against the selling pressure."
    label.new(bar_index, patternLabelPosLow, text="RW", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishRisingWindow)
C_FallingWindowBearishNumberOfCandles = 2
C_FallingWindowBearish = false
if C_DownTrend[1] and (C_Range!=0 and C_Range[1]!=0) and high < low[1]
	C_FallingWindowBearish := true
alertcondition(C_FallingWindowBearish, title = "Falling Window – Bearish", message = "New Falling Window – Bearish pattern detected")
if C_FallingWindowBearish  and  FallingWindowInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishFallingWindow = "Falling Window\nFalling Window is a two-candle bearish continuation pattern that forms during a downtrend. Both candles in the pattern can be of any type, with the exception of the Four-Price Doji. The most important characteristic of the pattern is a price gap between the first candle's low and the second candle's high. The existence of this gap (window) means that the bearish trend is expected to continue."
    label.new(bar_index, patternLabelPosHigh, text="FW", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishFallingWindow)
C_FallingThreeMethodsBearishNumberOfCandles = 5
C_FallingThreeMethodsBearish = false
if C_DownTrend[4] and (C_LongBody[4] and C_BlackBody[4]) and (C_SmallBody[3] and C_WhiteBody[3] and open[3]>low[4] and close[3]<high[4]) and (C_SmallBody[2] and C_WhiteBody[2] and open[2]>low[4] and close[2]<high[4]) and (C_SmallBody[1] and C_WhiteBody[1] and open[1]>low[4] and close[1]<high[4]) and (C_LongBody and C_BlackBody and close<close[4])
	C_FallingThreeMethodsBearish := true
alertcondition(C_FallingThreeMethodsBearish, title = "Falling Three Methods – Bearish", message = "New Falling Three Methods – Bearish pattern detected")
if C_FallingThreeMethodsBearish  and  FallingThreeMethodsInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishFallingThreeMethods = "Falling Three Methods\nFalling Three Methods is a five-candle bearish pattern that signifies a continuation of an existing downtrend. The first candle is long and red, followed by three short green candles with bodies inside the range of the first candle. The last candle is also red and long and it closes below the close of the first candle. This decisive fifth strongly bearish candle hints that bulls could not reverse the prior downtrend and that bears have regained control of the market."
    label.new(bar_index, patternLabelPosHigh, text="FTM", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishFallingThreeMethods)
C_RisingThreeMethodsBullishNumberOfCandles = 5
C_RisingThreeMethodsBullish = false
if C_UpTrend[4] and (C_LongBody[4] and C_WhiteBody[4]) and (C_SmallBody[3] and C_BlackBody[3] and open[3]<high[4] and close[3]>low[4]) and (C_SmallBody[2] and C_BlackBody[2] and open[2]<high[4] and close[2]>low[4]) and (C_SmallBody[1] and C_BlackBody[1] and open[1]<high[4] and close[1]>low[4]) and (C_LongBody and C_WhiteBody and close>close[4])
	C_RisingThreeMethodsBullish := true
alertcondition(C_RisingThreeMethodsBullish, title = "Rising Three Methods – Bullish", message = "New Rising Three Methods – Bullish pattern detected")
if C_RisingThreeMethodsBullish  and  RisingThreeMethodsInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishRisingThreeMethods = "Rising Three Methods\nRising Three Methods is a five-candle bullish pattern that signifies a continuation of an existing uptrend. The first candle is long and green, followed by three short red candles with bodies inside the range of the first candle. The last candle is also green and long and it closes above the close of the first candle. This decisive fifth strongly bullish candle hints that bears could not reverse the prior uptrend and that bulls have regained control of the market."
    label.new(bar_index, patternLabelPosLow, text="RTM", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishRisingThreeMethods)
C_TweezerTopBearishNumberOfCandles = 2
C_TweezerTopBearish = false
if C_UpTrend[1] and (not C_IsDojiBody or (C_HasUpShadow and C_HasDnShadow)) and math.abs(high-high[1]) <= C_BodyAvg*0.05 and C_WhiteBody[1] and C_BlackBody and C_LongBody[1]
	C_TweezerTopBearish := true
alertcondition(C_TweezerTopBearish, title = "Tweezer Top – Bearish", message = "New Tweezer Top – Bearish pattern detected")
if C_TweezerTopBearish  and  TweezerTopInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishTweezerTop = "Tweezer Top\nTweezer Top is a two-candle pattern that signifies a potential bearish reversal. The pattern is found during an uptrend. The first candle is long and green, the second candle is red, and its high is nearly identical to the high of the previous candle. The virtually identical highs, together with the inverted directions, hint that bears might be taking over the market."
    label.new(bar_index, patternLabelPosHigh, text="TT", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishTweezerTop)
C_TweezerBottomBullishNumberOfCandles = 2
C_TweezerBottomBullish = false
if C_DownTrend[1] and (not C_IsDojiBody or (C_HasUpShadow and C_HasDnShadow)) and math.abs(low-low[1]) <= C_BodyAvg*0.05 and C_BlackBody[1] and C_WhiteBody and C_LongBody[1]
	C_TweezerBottomBullish := true
alertcondition(C_TweezerBottomBullish, title = "Tweezer Bottom – Bullish", message = "New Tweezer Bottom – Bullish pattern detected")
if C_TweezerBottomBullish  and  TweezerBottomInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishTweezerBottom = "Tweezer Bottom\nTweezer Bottom is a two-candle pattern that signifies a potential bullish reversal. The pattern is found during a downtrend. The first candle is long and red, the second candle is green, its lows nearly identical to the low of the previous candle. The virtually identical lows together with the inverted directions hint that bulls might be taking over the market."
    label.new(bar_index, patternLabelPosLow, text="TB", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishTweezerBottom)
C_DarkCloudCoverBearishNumberOfCandles = 2
C_DarkCloudCoverBearish = false
if (C_UpTrend[1] and C_WhiteBody[1] and C_LongBody[1]) and (C_BlackBody and open >= high[1] and  close < C_BodyMiddle[1] and close > open[1])
	C_DarkCloudCoverBearish := true
alertcondition(C_DarkCloudCoverBearish, title = "Dark Cloud Cover – Bearish", message = "New Dark Cloud Cover – Bearish pattern detected")
if C_DarkCloudCoverBearish  and  DarkCloudCoverInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishDarkCloudCover = "Dark Cloud Cover\nDark Cloud Cover is a two-candle bearish reversal candlestick pattern found in an uptrend. The first candle is green and has a larger than average body. The second candle is red and opens above the high of the prior candle, creating a gap, and then closes below the midpoint of the first candle. The pattern shows a possible shift in the momentum from the upside to the downside, indicating that a reversal might happen soon."
    label.new(bar_index, patternLabelPosHigh, text="DCC", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishDarkCloudCover)
C_DownsideTasukiGapBearishNumberOfCandles = 3
C_DownsideTasukiGapBearish = false
if C_LongBody[2] and C_SmallBody[1] and C_DownTrend and C_BlackBody[2] and C_BodyHi[1] < C_BodyLo[2] and C_BlackBody[1] and C_WhiteBody and C_BodyHi <= C_BodyLo[2] and C_BodyHi >= C_BodyHi[1]
	C_DownsideTasukiGapBearish := true
alertcondition(C_DownsideTasukiGapBearish, title = "Downside Tasuki Gap – Bearish", message = "New Downside Tasuki Gap – Bearish pattern detected")
if C_DownsideTasukiGapBearish  and  DownsideTasukiGapInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishDownsideTasukiGap = "Downside Tasuki Gap\nDownside Tasuki Gap is a three-candle pattern found in a downtrend that usually hints at the continuation of the downtrend. The first candle is long and red, followed by a smaller red candle with its opening price that gaps below the body of the previous candle. The third candle is green and it closes inside the gap created by the first two candles, unable to close it fully. The bull’s inability to close that gap hints that the downtrend might continue."
    label.new(bar_index, patternLabelPosHigh, text="DTG", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishDownsideTasukiGap)
C_UpsideTasukiGapBullishNumberOfCandles = 3
C_UpsideTasukiGapBullish = false
if C_LongBody[2] and C_SmallBody[1] and C_UpTrend and C_WhiteBody[2] and C_BodyLo[1] > C_BodyHi[2] and C_WhiteBody[1] and C_BlackBody and C_BodyLo >= C_BodyHi[2] and C_BodyLo <= C_BodyLo[1]
	C_UpsideTasukiGapBullish := true
alertcondition(C_UpsideTasukiGapBullish, title = "Upside Tasuki Gap – Bullish", message = "New Upside Tasuki Gap – Bullish pattern detected")
if C_UpsideTasukiGapBullish  and  UpsideTasukiGapInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishUpsideTasukiGap = "Upside Tasuki Gap\nUpside Tasuki Gap is a three-candle pattern found in an uptrend that usually hints at the continuation of the uptrend. The first candle is long and green, followed by a smaller green candle with its opening price that gaps above the body of the previous candle. The third candle is red and it closes inside the gap created by the first two candles, unable to close it fully. The bear’s inability to close the gap hints that the uptrend might continue."
    label.new(bar_index, patternLabelPosLow, text="UTG", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishUpsideTasukiGap)
C_EveningDojiStarBearishNumberOfCandles = 3
C_EveningDojiStarBearish = false
if C_LongBody[2] and C_IsDojiBody[1] and C_LongBody and C_UpTrend and C_WhiteBody[2] and C_BodyLo[1] > C_BodyHi[2] and C_BlackBody and C_BodyLo <= C_BodyMiddle[2] and C_BodyLo > C_BodyLo[2] and C_BodyLo[1] > C_BodyHi
	C_EveningDojiStarBearish := true
alertcondition(C_EveningDojiStarBearish, title = "Evening Doji Star – Bearish", message = "New Evening Doji Star – Bearish pattern detected")
if C_EveningDojiStarBearish  and  EveningDojiStarInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishEveningDojiStar = "Evening Doji Star\nThis candlestick pattern is a variation of the Evening Star pattern. It is bearish and continues an uptrend with a long-bodied, green candle day. It is then followed by a gap and a Doji candle and concludes with a downward close. The close would be below the first day’s midpoint. It is more bearish than the regular evening star pattern because of the existence of the Doji."
    label.new(bar_index, patternLabelPosHigh, text="EDS", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishEveningDojiStar)
C_DojiStarBearishNumberOfCandles = 2
C_DojiStarBearish = false
if C_UpTrend and C_WhiteBody[1] and C_LongBody[1] and C_IsDojiBody and C_BodyLo > C_BodyHi[1]
	C_DojiStarBearish := true
alertcondition(C_DojiStarBearish, title = "Doji Star – Bearish", message = "New Doji Star – Bearish pattern detected")
if C_DojiStarBearish  and  DojiStarInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishDojiStar = "Doji Star\nThis is a bearish reversal candlestick pattern that is found in an uptrend and consists of two candles. First comes a long green candle, followed by a Doji candle (except 4-Price Doji) that opens above the body of the first one, creating a gap. It is considered a reversal signal with confirmation during the next trading day."
    label.new(bar_index, patternLabelPosHigh, text="DS", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishDojiStar)
C_DojiStarBullishNumberOfCandles = 2
C_DojiStarBullish = false
if C_DownTrend and C_BlackBody[1] and C_LongBody[1] and C_IsDojiBody and C_BodyHi < C_BodyLo[1]
	C_DojiStarBullish := true
alertcondition(C_DojiStarBullish, title = "Doji Star – Bullish", message = "New Doji Star – Bullish pattern detected")
if C_DojiStarBullish  and  DojiStarInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishDojiStar = "Doji Star\nThis is a bullish reversal candlestick pattern that is found in a downtrend and consists of two candles. First comes a long red candle, followed by a Doji candle (except 4-Price Doji) that opens below the body of the first one, creating a gap. It is considered a reversal signal with confirmation during the next trading day."
    label.new(bar_index, patternLabelPosLow, text="DS", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishDojiStar)
C_MorningDojiStarBullishNumberOfCandles = 3
C_MorningDojiStarBullish = false
if C_LongBody[2] and C_IsDojiBody[1] and C_LongBody and C_DownTrend and C_BlackBody[2] and C_BodyHi[1] < C_BodyLo[2] and C_WhiteBody and C_BodyHi >= C_BodyMiddle[2] and C_BodyHi < C_BodyHi[2] and C_BodyHi[1] < C_BodyLo
	C_MorningDojiStarBullish := true
alertcondition(C_MorningDojiStarBullish, title = "Morning Doji Star – Bullish", message = "New Morning Doji Star – Bullish pattern detected")
if C_MorningDojiStarBullish  and  MorningDojiStarInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishMorningDojiStar = "Morning Doji Star\nThis candlestick pattern is a variation of the Morning Star pattern. A three-day bullish reversal pattern, which consists of three candlesticks will look something like this: The first being a long-bodied red candle that extends the current downtrend. Next comes a Doji that gaps down on the open. After that comes a long-bodied green candle, which gaps up on the open and closes above the midpoint of the body of the first day. It is more bullish than the regular morning star pattern because of the existence of the Doji."
    label.new(bar_index, patternLabelPosLow, text="MDS", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishMorningDojiStar)
C_PiercingBullishNumberOfCandles = 2
C_PiercingBullish = false
if (C_DownTrend[1] and C_BlackBody[1] and C_LongBody[1]) and (C_WhiteBody and open <= low[1] and close > C_BodyMiddle[1] and close < open[1])
	C_PiercingBullish := true
alertcondition(C_PiercingBullish, title = "Piercing – Bullish", message = "New Piercing – Bullish pattern detected")
if C_PiercingBullish  and  PiercingInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishPiercing = "Piercing\nPiercing is a two-candle bullish reversal candlestick pattern found in a downtrend. The first candle is red and has a larger than average body. The second candle is green and opens below the low of the prior candle, creating a gap, and then closes above the midpoint of the first candle. The pattern shows a possible shift in the momentum from the downside to the upside, indicating that a reversal might happen soon."
    label.new(bar_index, patternLabelPosLow, text="P", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishPiercing)
C_HammerBullishNumberOfCandles = 1
C_HammerBullish = false
if C_SmallBody and C_Body > 0 and C_BodyLo > hl2 and C_DnShadow >= C_Factor * C_Body and not C_HasUpShadow
    if C_DownTrend
        C_HammerBullish := true
alertcondition(C_HammerBullish, title = "Hammer – Bullish", message = "New Hammer – Bullish pattern detected")
if C_HammerBullish  and  HammerInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishHammer = "Hammer\nHammer candlesticks form when a security moves lower after the open, but continues to rally into close above the intraday low. The candlestick that you are left with will look like a square attached to a long stick-like figure. This candlestick is called a Hammer if it happens to form during a decline."
    label.new(bar_index, patternLabelPosLow, text="H", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishHammer)
C_HangingManBearishNumberOfCandles = 1
C_HangingManBearish = false
if C_SmallBody and C_Body > 0 and C_BodyLo > hl2 and C_DnShadow >= C_Factor * C_Body and not C_HasUpShadow
	if C_UpTrend
	    C_HangingManBearish := true
alertcondition(C_HangingManBearish, title = "Hanging Man – Bearish", message = "New Hanging Man – Bearish pattern detected")
if C_HangingManBearish  and  HangingManInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishHangingMan = "Hanging Man\nWhen a specified security notably moves lower after the open, but continues to rally to close above the intraday low, a Hanging Man candlestick will form. The candlestick will resemble a square, attached to a long stick-like figure. It is referred to as a Hanging Man if the candlestick forms during an advance."
    label.new(bar_index, patternLabelPosHigh, text="HM", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishHangingMan)
C_ShootingStarBearishNumberOfCandles = 1
C_ShootingStarBearish = false
if C_SmallBody and C_Body > 0 and C_BodyHi < hl2 and C_UpShadow >= C_Factor * C_Body and not C_HasDnShadow
	if C_UpTrend
	    C_ShootingStarBearish := true
alertcondition(C_ShootingStarBearish, title = "Shooting Star – Bearish", message = "New Shooting Star – Bearish pattern detected")
if C_ShootingStarBearish  and  ShootingStarInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishShootingStar = "Shooting Star\nThis single day pattern can appear during an uptrend and opens high, while it closes near its open. It trades much higher as well. It is bearish in nature, but looks like an Inverted Hammer."
    label.new(bar_index, patternLabelPosHigh, text="SS", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishShootingStar)
C_InvertedHammerBullishNumberOfCandles = 1
C_InvertedHammerBullish = false
if C_SmallBody and C_Body > 0 and C_BodyHi < hl2 and C_UpShadow >= C_Factor * C_Body and not C_HasDnShadow
    if C_DownTrend
        C_InvertedHammerBullish := true
alertcondition(C_InvertedHammerBullish, title = "Inverted Hammer – Bullish", message = "New Inverted Hammer – Bullish pattern detected")
if C_InvertedHammerBullish  and  InvertedHammerInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishInvertedHammer = "Inverted Hammer\nIf in a downtrend, then the open is lower. When it eventually trades higher, but closes near its open, it will look like an inverted version of the Hammer Candlestick. This is a one-day bullish reversal pattern."
    label.new(bar_index, patternLabelPosLow, text="IH", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishInvertedHammer)
C_MorningStarBullishNumberOfCandles = 3
C_MorningStarBullish = false
if C_LongBody[2] and C_SmallBody[1] and C_LongBody
    if C_DownTrend and C_BlackBody[2] and C_BodyHi[1] < C_BodyLo[2] and C_WhiteBody and C_BodyHi >= C_BodyMiddle[2] and C_BodyHi < C_BodyHi[2] and C_BodyHi[1] < C_BodyLo
        C_MorningStarBullish := true
alertcondition(C_MorningStarBullish, title = "Morning Star – Bullish", message = "New Morning Star – Bullish pattern detected")
if C_MorningStarBullish  and  MorningStarInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishMorningStar = "Morning Star\nA three-day bullish reversal pattern, which consists of three candlesticks will look something like this: The first being a long-bodied red candle that extends the current downtrend. Next comes a short, middle candle that gaps down on the open. After comes a long-bodied green candle, which gaps up on the open and closes above the midpoint of the body of the first day."
    label.new(bar_index, patternLabelPosLow, text="MS", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishMorningStar)
C_EveningStarBearishNumberOfCandles = 3
C_EveningStarBearish = false
if C_LongBody[2] and C_SmallBody[1] and C_LongBody
    if C_UpTrend and C_WhiteBody[2] and C_BodyLo[1] > C_BodyHi[2] and C_BlackBody and C_BodyLo <= C_BodyMiddle[2] and C_BodyLo > C_BodyLo[2] and C_BodyLo[1] > C_BodyHi
        C_EveningStarBearish := true
alertcondition(C_EveningStarBearish, title = "Evening Star – Bearish", message = "New Evening Star – Bearish pattern detected")
if C_EveningStarBearish  and  EveningStarInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishEveningStar = "Evening Star\nThis candlestick pattern is bearish and continues an uptrend with a long-bodied, green candle day. It is then followed by a gapped and small-bodied candle day, and concludes with a downward close. The close would be below the first day’s midpoint."
    label.new(bar_index, patternLabelPosHigh, text="ES", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishEveningStar)
C_MarubozuWhiteBullishNumberOfCandles = 1
C_MarubozuShadowPercentWhite = 5.0
C_MarubozuWhiteBullish = C_WhiteBody and C_LongBody and C_UpShadow <= C_MarubozuShadowPercentWhite/100*C_Body and C_DnShadow <= C_MarubozuShadowPercentWhite/100*C_Body and C_WhiteBody
alertcondition(C_MarubozuWhiteBullish, title = "Marubozu White – Bullish", message = "New Marubozu White – Bullish pattern detected")
if C_MarubozuWhiteBullish  and  MarubozuWhiteInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishMarubozuWhite = "Marubozu White\nA Marubozu White Candle is a candlestick that does not have a shadow that extends from its candle body at either the open or the close. Marubozu is Japanese for “close-cropped” or “close-cut.” Other sources may call it a Bald or Shaven Head Candle."
    label.new(bar_index, patternLabelPosLow, text="MW", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishMarubozuWhite)
C_MarubozuBlackBearishNumberOfCandles = 1
C_MarubozuShadowPercentBearish = 5.0
C_MarubozuBlackBearish = C_BlackBody and C_LongBody and C_UpShadow <= C_MarubozuShadowPercentBearish/100*C_Body and C_DnShadow <= C_MarubozuShadowPercentBearish/100*C_Body and C_BlackBody
alertcondition(C_MarubozuBlackBearish, title = "Marubozu Black – Bearish", message = "New Marubozu Black – Bearish pattern detected")
if C_MarubozuBlackBearish  and  MarubozuBlackInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishMarubozuBlack = "Marubozu Black\nThis is a candlestick that has no shadow, which extends from the red-bodied candle at the open, the close, or even at both. In Japanese, the name means “close-cropped” or “close-cut.” The candlestick can also be referred to as Bald or Shaven Head."
    label.new(bar_index, patternLabelPosHigh, text="MB", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishMarubozuBlack)
C_DojiNumberOfCandles = 1
C_DragonflyDoji = C_IsDojiBody and C_UpShadow <= C_Body
C_GravestoneDojiOne = C_IsDojiBody and C_DnShadow <= C_Body
alertcondition(C_Doji and not C_DragonflyDoji and not C_GravestoneDojiOne, title = "Doji", message = "New Doji pattern detected")
if C_Doji and not C_DragonflyDoji and not C_GravestoneDojiOne and DojiInput
    var ttDoji = "Doji\nWhen the open and close of a security are essentially equal to each other, a doji candle forms. The length of both upper and lower shadows may vary, causing the candlestick you are left with to either resemble a cross, an inverted cross, or a plus sign. Doji candles show the playout of buyer-seller indecision in a tug-of-war of sorts. As price moves either above or below the opening level during the session, the close is either at or near the opening level."
    label.new(bar_index, patternLabelPosLow, text="D", style=label.style_label_up, color = label_color_neutral, textcolor=color.white, tooltip = ttDoji)
C_GravestoneDojiBearishNumberOfCandles = 1
C_GravestoneDojiBearish = C_IsDojiBody and C_DnShadow <= C_Body
alertcondition(C_GravestoneDojiBearish, title = "Gravestone Doji – Bearish", message = "New Gravestone Doji – Bearish pattern detected")
if C_GravestoneDojiBearish  and  GravestoneDojiInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishGravestoneDoji = "Gravestone Doji\nWhen a doji is at or is close to the day’s low point, a doji line will develop."
    label.new(bar_index, patternLabelPosHigh, text="GD", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishGravestoneDoji)
C_DragonflyDojiBullishNumberOfCandles = 1
C_DragonflyDojiBullish = C_IsDojiBody and C_UpShadow <= C_Body
alertcondition(C_DragonflyDojiBullish, title = "Dragonfly Doji – Bullish", message = "New Dragonfly Doji – Bullish pattern detected")
if C_DragonflyDojiBullish  and  DragonflyDojiInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishDragonflyDoji = "Dragonfly Doji\nSimilar to other Doji days, this particular Doji also regularly appears at pivotal market moments. This is a specific Doji where both the open and close price are at the high of a given day."
    label.new(bar_index, patternLabelPosLow, text="DD", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishDragonflyDoji)
C_HaramiCrossBullishNumberOfCandles = 2
C_HaramiCrossBullish = C_LongBody[1] and C_BlackBody[1] and C_DownTrend[1] and C_IsDojiBody and high <= C_BodyHi[1] and low >= C_BodyLo[1]
alertcondition(C_HaramiCrossBullish, title = "Harami Cross – Bullish", message = "New Harami Cross – Bullish pattern detected")
if C_HaramiCrossBullish  and  HaramiCrossInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishHaramiCross = "Harami Cross\nThis candlestick pattern is a variation of the Harami Bullish pattern. It is found during a downtrend. The two-day candlestick pattern consists of a Doji candle that is entirely encompassed within the body of what was once a red-bodied candle."
    label.new(bar_index, patternLabelPosLow, text="HC", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishHaramiCross)
C_HaramiCrossBearishNumberOfCandles = 2
C_HaramiCrossBearish = C_LongBody[1] and C_WhiteBody[1] and C_UpTrend[1] and C_IsDojiBody and high <= C_BodyHi[1] and low >= C_BodyLo[1]
alertcondition(C_HaramiCrossBearish, title = "Harami Cross – Bearish", message = "New Harami Cross – Bearish pattern detected")
if C_HaramiCrossBearish  and  HaramiCrossInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishHaramiCross = "Harami Cross\nThis candlestick pattern is a variation of the Harami Bearish pattern. It is found during an uptrend. This is a two-day candlestick pattern with a Doji candle that is entirely encompassed within the body that was once a green-bodied candle. The Doji shows that some indecision has entered the minds of sellers, and the pattern hints that the trend might reverse."
    label.new(bar_index, patternLabelPosHigh, text="HC", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishHaramiCross)
C_HaramiBullishNumberOfCandles = 2
C_HaramiBullish = C_LongBody[1] and C_BlackBody[1] and C_DownTrend[1] and C_WhiteBody and C_SmallBody and high <= C_BodyHi[1] and low >= C_BodyLo[1]
alertcondition(C_HaramiBullish, title = "Harami – Bullish", message = "New Harami – Bullish pattern detected")
if C_HaramiBullish  and  HaramiInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishHarami = "Harami\nThis two-day candlestick pattern consists of a small-bodied green candle that is entirely encompassed within the body of what was once a red-bodied candle."
    label.new(bar_index, patternLabelPosLow, text="BH", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishHarami)
C_HaramiBearishNumberOfCandles = 2
C_HaramiBearish = C_LongBody[1] and C_WhiteBody[1] and C_UpTrend[1] and C_BlackBody and C_SmallBody and high <= C_BodyHi[1] and low >= C_BodyLo[1]
alertcondition(C_HaramiBearish, title = "Harami – Bearish", message = "New Harami – Bearish pattern detected")
if C_HaramiBearish  and  HaramiInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishHarami = "Harami\nThis is a two-day candlestick pattern with a small, red-bodied candle that is entirely encompassed within the body that was once a green-bodied candle."
    label.new(bar_index, patternLabelPosHigh, text="BH", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishHarami)
C_LongLowerShadowBullishNumberOfCandles = 1
C_LongLowerShadowPercent = 75.0
C_LongLowerShadowBullish = C_DnShadow > C_Range/100*C_LongLowerShadowPercent
alertcondition(C_LongLowerShadowBullish, title = "Long Lower Shadow – Bullish", message = "New Long Lower Shadow – Bullish pattern detected")
if C_LongLowerShadowBullish  and  LongLowerShadowInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishLongLowerShadow = "Long Lower Shadow\nTo indicate seller domination of the first part of a session, candlesticks will present with long lower shadows and short upper shadows, consequently lowering prices."
    label.new(bar_index, patternLabelPosLow, text="LLS", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishLongLowerShadow)
C_LongUpperShadowBearishNumberOfCandles = 1
C_LongShadowPercent = 75.0
C_LongUpperShadowBearish = C_UpShadow > C_Range/100*C_LongShadowPercent
alertcondition(C_LongUpperShadowBearish, title = "Long Upper Shadow – Bearish", message = "New Long Upper Shadow – Bearish pattern detected")
if C_LongUpperShadowBearish  and  LongUpperShadowInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishLongUpperShadow = "Long Upper Shadow\nTo indicate buyer domination of the first part of a session, candlesticks will present with long upper shadows, as well as short lower shadows, consequently raising bidding prices."
    label.new(bar_index, patternLabelPosHigh, text="LUS", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishLongUpperShadow)
C_SpinningTopWhiteNumberOfCandles = 1
C_SpinningTopWhitePercent = 34.0
C_IsSpinningTopWhite = C_DnShadow >= C_Range / 100 * C_SpinningTopWhitePercent and C_UpShadow >= C_Range / 100 * C_SpinningTopWhitePercent and not C_IsDojiBody
C_SpinningTopWhite = C_IsSpinningTopWhite and C_WhiteBody
alertcondition(C_SpinningTopWhite, title = "Spinning Top White", message = "New Spinning Top White pattern detected")
if C_SpinningTopWhite and SpinningTopWhiteInput
    var ttSpinningTopWhite = "Spinning Top White\nWhite spinning tops are candlestick lines that are small, green-bodied, and possess shadows (upper and lower) that end up exceeding the length of candle bodies. They often signal indecision between buyer and seller."
    label.new(bar_index, patternLabelPosLow, text="STW", style=label.style_label_up, color = label_color_neutral, textcolor=color.white, tooltip = ttSpinningTopWhite)
C_SpinningTopBlackNumberOfCandles = 1
C_SpinningTopBlackPercent = 34.0
C_IsSpinningTop = C_DnShadow >= C_Range / 100 * C_SpinningTopBlackPercent and C_UpShadow >= C_Range / 100 * C_SpinningTopBlackPercent and not C_IsDojiBody
C_SpinningTopBlack = C_IsSpinningTop and C_BlackBody
alertcondition(C_SpinningTopBlack, title = "Spinning Top Black", message = "New Spinning Top Black pattern detected")
if C_SpinningTopBlack and SpinningTopBlackInput
    var ttSpinningTopBlack = "Spinning Top Black\nBlack spinning tops are candlestick lines that are small, red-bodied, and possess shadows (upper and lower) that end up exceeding the length of candle bodies. They often signal indecision."
    label.new(bar_index, patternLabelPosLow, text="STB", style=label.style_label_up, color = label_color_neutral, textcolor=color.white, tooltip = ttSpinningTopBlack)
C_ThreeWhiteSoldiersBullishNumberOfCandles = 3
C_3WSld_ShadowPercent = 5.0
C_3WSld_HaveNotUpShadow = C_Range * C_3WSld_ShadowPercent / 100 > C_UpShadow
C_ThreeWhiteSoldiersBullish = false
if C_LongBody and C_LongBody[1] and C_LongBody[2]
    if C_WhiteBody and C_WhiteBody[1] and C_WhiteBody[2]
        C_ThreeWhiteSoldiersBullish := close > close[1] and close[1] > close[2] and open < close[1] and open > open[1] and open[1] < close[2] and open[1] > open[2] and C_3WSld_HaveNotUpShadow and C_3WSld_HaveNotUpShadow[1] and C_3WSld_HaveNotUpShadow[2]
alertcondition(C_ThreeWhiteSoldiersBullish, title = "Three White Soldiers – Bullish", message = "New Three White Soldiers – Bullish pattern detected")
if C_ThreeWhiteSoldiersBullish  and  ThreeWhiteSoldiersInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishThreeWhiteSoldiers = "Three White Soldiers\nThis bullish reversal pattern is made up of three long-bodied, green candles in immediate succession. Each one opens within the body before it and the close is near to the daily high."
    label.new(bar_index, patternLabelPosLow, text="3WS", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishThreeWhiteSoldiers)
C_ThreeBlackCrowsBearishNumberOfCandles = 3
C_3BCrw_ShadowPercent = 5.0
C_3BCrw_HaveNotDnShadow = C_Range * C_3BCrw_ShadowPercent / 100 > C_DnShadow
C_ThreeBlackCrowsBearish = false
if C_LongBody and C_LongBody[1] and C_LongBody[2]
    if C_BlackBody and C_BlackBody[1] and C_BlackBody[2]
        C_ThreeBlackCrowsBearish := close < close[1] and close[1] < close[2] and open > close[1] and open < open[1] and open[1] > close[2] and open[1] < open[2] and C_3BCrw_HaveNotDnShadow and C_3BCrw_HaveNotDnShadow[1] and C_3BCrw_HaveNotDnShadow[2]
alertcondition(C_ThreeBlackCrowsBearish, title = "Three Black Crows – Bearish", message = "New Three Black Crows – Bearish pattern detected")
if C_ThreeBlackCrowsBearish  and  ThreeBlackCrowsInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishThreeBlackCrows = "Three Black Crows\nThis is a bearish reversal pattern that consists of three long, red-bodied candles in immediate succession. For each of these candles, each day opens within the body of the day before and closes either at or near its low."
    label.new(bar_index, patternLabelPosHigh, text="3BC", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishThreeBlackCrows)
C_EngulfingBullishNumberOfCandles = 2
C_EngulfingBullish = C_DownTrend and C_WhiteBody and C_LongBody and C_BlackBody[1] and C_SmallBody[1] and close >= open[1] and open <= close[1] and ( close > open[1] or open < close[1] )
alertcondition(C_EngulfingBullish, title = "Engulfing – Bullish", message = "New Engulfing – Bullish pattern detected")
if C_EngulfingBullish  and  EngulfingInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishEngulfing = "Engulfing\nAt the end of a given downward trend, there will most likely be a reversal pattern. To distinguish the first day, this candlestick pattern uses a small body, followed by a day where the candle body fully overtakes the body from the day before, and closes in the trend’s opposite direction. Although similar to the outside reversal chart pattern, it is not essential for this pattern to completely overtake the range (high to low), rather only the open and the close."
    label.new(bar_index, patternLabelPosLow, text="BE", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishEngulfing)
C_EngulfingBearishNumberOfCandles = 2
C_EngulfingBearish = C_UpTrend and C_BlackBody and C_LongBody and C_WhiteBody[1] and C_SmallBody[1] and close <= open[1] and open >= close[1] and ( close < open[1] or open > close[1] )
alertcondition(C_EngulfingBearish, title = "Engulfing – Bearish", message = "New Engulfing – Bearish pattern detected")
if C_EngulfingBearish  and  EngulfingInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishEngulfing = "Engulfing\nAt the end of a given uptrend, a reversal pattern will most likely appear. During the first day, this candlestick pattern uses a small body. It is then followed by a day where the candle body fully overtakes the body from the day before it and closes in the trend’s opposite direction. Although similar to the outside reversal chart pattern, it is not essential for this pattern to fully overtake the range (high to low), rather only the open and the close."
    label.new(bar_index, patternLabelPosHigh, text="BE", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishEngulfing)
C_AbandonedBabyBullishNumberOfCandles = 3
C_AbandonedBabyBullish = C_DownTrend[2] and C_BlackBody[2] and C_IsDojiBody[1] and low[2] > high[1] and C_WhiteBody and high[1] < low
alertcondition(C_AbandonedBabyBullish, title = "Abandoned Baby – Bullish", message = "New Abandoned Baby – Bullish pattern detected")
if C_AbandonedBabyBullish  and  AbandonedBabyInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishAbandonedBaby = "Abandoned Baby\nThis candlestick pattern is quite rare as far as reversal patterns go. The first of the pattern is a large down candle. Next comes a doji candle that gaps below the candle before it. The doji candle is then followed by another candle that opens even higher and swiftly moves to the upside."
    label.new(bar_index, patternLabelPosLow, text="AB", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishAbandonedBaby)
C_AbandonedBabyBearishNumberOfCandles = 3
C_AbandonedBabyBearish = C_UpTrend[2] and C_WhiteBody[2] and C_IsDojiBody[1] and high[2] < low[1] and C_BlackBody and low[1] > high
alertcondition(C_AbandonedBabyBearish, title = "Abandoned Baby – Bearish", message = "New Abandoned Baby – Bearish pattern detected")
if C_AbandonedBabyBearish  and  AbandonedBabyInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishAbandonedBaby = "Abandoned Baby\nA bearish abandoned baby is a specific candlestick pattern that often signals a downward reversal trend in terms of security price. It is formed when a gap appears between the lowest price of a doji-like candle and the candlestick of the day before. The earlier candlestick is green, tall, and has small shadows. The doji candle is also tailed by a gap between its lowest price point and the highest price point of the candle that comes next, which is red, tall and also has small shadows. The doji candle shadows must completely gap either below or above the shadows of the first and third day in order to have the abandoned baby pattern effect."
    label.new(bar_index, patternLabelPosHigh, text="AB", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishAbandonedBaby)
C_TriStarBullishNumberOfCandles = 3
C_3DojisBullish = C_Doji[2] and C_Doji[1] and C_Doji
C_BodyGapUpBullish = C_BodyHi[1] < C_BodyLo
C_BodyGapDnBullish = C_BodyLo[1] > C_BodyHi
C_TriStarBullish = C_3DojisBullish and C_DownTrend[2] and C_BodyGapDnBullish[1] and C_BodyGapUpBullish
alertcondition(C_TriStarBullish, title = "Tri-Star – Bullish", message = "New Tri-Star – Bullish pattern detected")
if C_TriStarBullish  and  TriStarInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishTriStar = "Tri-Star\nA bullish TriStar candlestick pattern can form when three doji candlesticks materialize in immediate succession at the tail-end of an extended downtrend. The first doji candle marks indecision between bull and bear. The second doji gaps in the direction of the leading trend. The third changes the attitude of the market once the candlestick opens in the direction opposite to the trend. Each doji candle has a shadow, all comparatively shallow, which signify an interim cutback in volatility."
    label.new(bar_index, patternLabelPosLow, text="3S", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishTriStar)
C_TriStarBearishNumberOfCandles = 3
C_3Dojis = C_Doji[2] and C_Doji[1] and C_Doji
C_BodyGapUp = C_BodyHi[1] < C_BodyLo
C_BodyGapDn = C_BodyLo[1] > C_BodyHi
C_TriStarBearish = C_3Dojis and C_UpTrend[2] and C_BodyGapUp[1] and C_BodyGapDn
alertcondition(C_TriStarBearish, title = "Tri-Star – Bearish", message = "New Tri-Star – Bearish pattern detected")
if C_TriStarBearish  and  TriStarInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishTriStar = "Tri-Star\nThis particular pattern can form when three doji candlesticks appear in immediate succession at the end of an extended uptrend. The first doji candle marks indecision between bull and bear. The second doji gaps in the direction of the leading trend. The third changes the attitude of the market once the candlestick opens in the direction opposite to the trend. Each doji candle has a shadow, all comparatively shallow, which signify an interim cutback in volatility."
    label.new(bar_index, patternLabelPosHigh, text="3S", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishTriStar)
C_KickingBullishNumberOfCandles = 2
C_MarubozuShadowPercent = 5.0
C_Marubozu = C_LongBody and C_UpShadow <= C_MarubozuShadowPercent/100*C_Body and C_DnShadow <= C_MarubozuShadowPercent/100*C_Body
C_MarubozuWhiteBullishKicking = C_Marubozu and C_WhiteBody
C_MarubozuBlackBullish = C_Marubozu and C_BlackBody
C_KickingBullish = C_MarubozuBlackBullish[1] and C_MarubozuWhiteBullishKicking and high[1] < low
alertcondition(C_KickingBullish, title = "Kicking – Bullish", message = "New Kicking – Bullish pattern detected")
if C_KickingBullish  and  KickingInput and (("Bullish" == CandleType) or CandleType == "Both")

    var ttBullishKicking = "Kicking\nThe first day candlestick is a bearish marubozu candlestick with next to no upper or lower shadow and where the price opens at the day’s high and closes at the day’s low. The second day is a bullish marubozu pattern, with next to no upper or lower shadow and where the price opens at the day’s low and closes at the day’s high. Additionally, the second day gaps up extensively and opens above the opening price of the day before. This gap or window, as the Japanese call it, lies between day one and day two’s bullish candlesticks."
    label.new(bar_index, patternLabelPosLow, text="K", style=label.style_label_up, color = label_color_bullish, textcolor=color.white, tooltip = ttBullishKicking)
C_KickingBearishNumberOfCandles = 2
C_MarubozuBullishShadowPercent = 5.0
C_MarubozuBearishKicking = C_LongBody and C_UpShadow <= C_MarubozuBullishShadowPercent/100*C_Body and C_DnShadow <= C_MarubozuBullishShadowPercent/100*C_Body
C_MarubozuWhiteBearish = C_MarubozuBearishKicking and C_WhiteBody
C_MarubozuBlackBearishKicking = C_MarubozuBearishKicking and C_BlackBody
C_KickingBearish = C_MarubozuWhiteBearish[1] and C_MarubozuBlackBearishKicking and low[1] > high
alertcondition(C_KickingBearish, title = "Kicking – Bearish", message = "New Kicking – Bearish pattern detected")
if C_KickingBearish  and  KickingInput and (("Bearish" == CandleType) or CandleType == "Both")

    var ttBearishKicking = "Kicking\nA bearish kicking pattern will occur, subsequently signaling a reversal for a new downtrend. The first day candlestick is a bullish marubozu. The second day gaps down extensively and opens below the opening price of the day before. There is a gap between day one and two’s bearish candlesticks."
    label.new(bar_index, patternLabelPosHigh, text="K", style=label.style_label_down, color = label_color_bearish, textcolor=color.white, tooltip = ttBearishKicking)
    var ttAllCandlestickPatterns = "All Candlestick Patterns\n"
    label.new(bar_index, patternLabelPosLow, text="Collection", style=label.style_label_up, color = label_color_neutral, textcolor=color.white, tooltip = ttAllCandlestickPatterns)

 # RSI

//@version=5
strategy("RSI Strategy", overlay=true)
length = input( 14 )
overSold = input( 30 )
overBought = input( 70 )
price = close
vrsi = ta.rsi(price, length)
co = ta.crossover(vrsi, overSold)
cu = ta.crossunder(vrsi, overBought)
if (not na(vrsi))
	if (co)
		strategy.entry("RsiLE", strategy.long, comment="RsiLE")
	if (cu)
		strategy.entry("RsiSE", strategy.short, comment="RsiSE")
//plot(strategy.equity, title="equity", color=color.red, linewidth=2, style=plot.style_areabr)


 # EMA Ribbon

//@version=3
study(title="EMA Ribbon [Krypt]", shorttitle="EMA Ribbon", overlay=true)

dropn(src, n) =>
    na(src[n]) ? na : src

length1 = input(20, title="MA-1 period", minval=1)
length2 = input(25, title="MA-2 period", minval=1)
length3 = input(30, title="MA-3 period", minval=1)
length4 = input(35, title="MA-4 period", minval=1)
length5 = input(40, title="MA-5 period", minval=1)
length6 = input(45, title="MA-6 period", minval=1)
length7 = input(50, title="MA-7 period", minval=1)
length8 = input(55, title="MA-8 period", minval=1)
src = input(close, type=source, title="Source")
dropCandles = input(1, minval=0, title="Drop first N candles")

price = dropn(src, dropCandles)

plot(ema(price, length1), title="MA-1", color=#f5eb5d, transp=0, linewidth=2)
plot(ema(price, length2), title="MA-2", color=#f5b771, transp=0, linewidth=2)
plot(ema(price, length3), title="MA-3", color=#f5b056, transp=0, linewidth=2)
plot(ema(price, length4), title="MA-4", color=#f57b4e, transp=0, linewidth=2)
plot(ema(price, length5), title="MA-5", color=#f56d58, transp=0, linewidth=2)
plot(ema(price, length6), title="MA-6", color=#f57d51, transp=0, linewidth=2)
plot(ema(price, length7), title="MA-7", color=#f55151, transp=0, linewidth=2)
plot(ema(price, length8), title="MA-8", color=#aa2707, transp=0, linewidth=2)

