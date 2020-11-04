import wNim/[wApp, wFrame,wPanel,wButton,wFont,wTextCtrl,wStaticText,
    wStaticBox,wStatusBar,wMessageDialog]
import RIGOL_DP832/wRsrcCtrl
import nimvisa
import strutils,strformat



let app = App()
let frame = Frame(title="RIGOL DP832 Power Supply",size=(640,400))
let panel = Panel(frame)
let statusBar = StatusBar(frame)
statusBar.setFieldsCount(2)
statusBar.setStatusText("offline",0)

let lbl_addr = StaticText(panel, label= "VIAS Addr:",pos=(10,30))
let rctl = RsrcCtrl(panel,pos=(70,28))
let btn_conn = Button(panel,label="Connect",size=(100,70),pos=(390,10))
btn_conn.font = Font(12, family=wFontFamilySwiss, weight=wFontWeightBold)
let btn_onoff = Button(panel,label="All On/Off",size=(100,70), pos=(510,10))
btn_onoff.font = Font(12, family=wFontFamilySwiss, weight=wFontWeightBold)

#------ for ch1
let staticbox1 = StaticBox(panel, label="CH1 (30V/3A)",size=(180,200),pos=(10,100),style=wBorderSimple)
let lbl_V1  = StaticText(panel, label= "Volt(V)", pos=(20,130))
let lbl_A1  = StaticText(panel, label= "Curr(A)", pos=(20,160))
let lbl_VH1 = StaticText(panel, label= "VH_Limit(V)", pos=(20,190))
let lbl_VL1 = StaticText(panel, label= "VL_Limit(V)", pos=(20,220))
let txt_V1  = TextCtrl(panel, value="", size=(50,23),pos=(85,130-3),style=wBorderSimple)
let txt_A1  = TextCtrl(panel, value="", size=(50,23),pos=(85,160-3),style=wBorderSimple)
let txt_VH1 = TextCtrl(panel, value="", size=(50,23),pos=(85,190-3),style=wBorderSimple)
let txt_VL1 = TextCtrl(panel, value="", size=(50,23),pos=(85,220-3),style=wBorderSimple)
let btn_ch1 = Button(panel,label="Apply",size=(80,40), pos=(60,250))
btn_ch1.font = Font(12, family=wFontFamilySwiss, weight=wFontWeightBold)

#------ for ch2
let staticbox2 = StaticBox(panel, label="CH2 (30V/3A)",size=(180,200),pos=(210,100),style=wBorderSimple)
let lbl_V2  = StaticText(panel, label= "Volt(V)", pos=(220,130))
let lbl_A2  = StaticText(panel, label= "Curr(A)", pos=(220,160))
let lbl_VH2 = StaticText(panel, label= "VH_Limit(V)", pos=(220,190))
let lbl_VL2 = StaticText(panel, label= "VL_Limit(V)", pos=(220,220))
let txt_V2  = TextCtrl(panel, value="", size=(50,23),pos=(285,130-3),style=wBorderSimple)
let txt_A2  = TextCtrl(panel, value="", size=(50,23),pos=(285,160-3),style=wBorderSimple)
let txt_VH2 = TextCtrl(panel, value="", size=(50,23),pos=(285,190-3),style=wBorderSimple)
let txt_VL2 = TextCtrl(panel, value="", size=(50,23),pos=(285,220-3),style=wBorderSimple)
let btn_ch2 = Button(panel,label="Apply",size=(80,40), pos=(260,250))
btn_ch2.font = Font(12, family=wFontFamilySwiss, weight=wFontWeightBold)


#------ for ch3
let staticbox3 = StaticBox(panel, label="CH3 (5V/3A)",size=(180,200),pos=(410,100),style=wBorderSimple)
let lbl_V3  = StaticText(panel, label= "Volt(V)", pos=(420,130))
let lbl_A3  = StaticText(panel, label= "Curr(A)", pos=(420,160))
let lbl_VH3 = StaticText(panel, label= "VH_Limit(V)", pos=(420,190))
let lbl_VL3 = StaticText(panel, label= "VL_Limit(V)", pos=(420,220))
let txt_V3  = TextCtrl(panel, value="", size=(50,23),pos=(485,130-3),style=wBorderSimple)
let txt_A3  = TextCtrl(panel, value="", size=(50,23),pos=(485,160-3),style=wBorderSimple)
let txt_VH3 = TextCtrl(panel, value="", size=(50,23),pos=(485,190-3),style=wBorderSimple)
let txt_VL3 = TextCtrl(panel, value="", size=(50,23),pos=(485,220-3),style=wBorderSimple)
let btn_ch3 = Button(panel,label="Apply",size=(80,40), pos=(460,250))
btn_ch3.font = Font(12, family=wFontFamilySwiss, weight=wFontWeightBold)

var my_instrument:Resource

btn_conn.wEvent_Button do ():
  var idn_seq:seq[string]
  var noexception:bool = true
  try:
    let rm = newResourceManager()
    my_instrument = rm.open_resource(rctl.getValue())
    let idn = my_instrument.query("*IDN?")
    idn_seq = idn.split(',')
  except:
    discard MessageDialog(frame, message="some error happened when connect to instrument", 
        caption="Connection Failed", style=wOK).display()
    statusBar.setStatusText("offline",0)
    noexception = false
  if noexception:
    if idn_seq[0] != "RIGOL TECHNOLOGIES":
      statusBar.setStatusText("offline",0)
      discard MessageDialog(frame, message="It is not valid instrument from RIGOL TECHNOLOGIES\nMaybe you are selecting a wrong address", 
          caption="Wrong Instrument", style=wOK).display()
    elif idn_seq[1] != "DP832":
      statusBar.setStatusText("offline",0)
      discard MessageDialog(frame, message="It is not DP832 model\nMaybe you are selecting a wrong address", 
          caption="Wrong Instrument", style=wOK).display()
    else:
      statusBar.setStatusText("online",0)
      var res = my_instrument.query(":APPL? CH1").strip().split(",")
      txt_V1.setValue(res[1])
      txt_A1.setValue(res[2])
      txt_VH1.setValue(fmt"{parseFloat(res[1])*1.15:0.3f}")
      txt_VL1.setValue(fmt"{parseFloat(res[1])*0.85:0.3f}")
      res = my_instrument.query(":APPL? CH2").strip().split(",")
      txt_V2.setValue(res[1])
      txt_A2.setValue(res[2])
      txt_VH2.setValue(fmt"{parseFloat(res[1])*1.15:0.3f}")
      txt_VL2.setValue(fmt"{parseFloat(res[1])*0.85:0.3f}")      
      res = my_instrument.query(":APPL? CH3").strip().split(",")
      txt_V3.setValue(res[1])
      txt_A3.setValue(res[2])
      txt_VH3.setValue(fmt"{parseFloat(res[1])*1.15:0.3f}")
      txt_VL3.setValue(fmt"{parseFloat(res[1])*0.85:0.3f}")      

var output_state = false
btn_onoff.wEvent_Button do ():
  if output_state:
    my_instrument.write("OUTP CH1,OFF")
    my_instrument.write("OUTP CH2,OFF")
    my_instrument.write("OUTP CH3,OFF")
  else:
    my_instrument.write("OUTP CH1,ON")
    my_instrument.write("OUTP CH2,ON")
    my_instrument.write("OUTP CH3,ON")    
  output_state = not output_state

proc apply_voltage(ch:int) =
  let volt = [txt_V1.getValue(),txt_V2.getValue(),txt_V3.getValue()]
  let curr = [txt_A1.getValue(),txt_A2.getValue(),txt_A3.getValue()]
  let volt_h = [txt_VH1.getValue(),txt_VH2.getValue(),txt_VH3.getValue()]
  let volt_l = [txt_VL1.getValue(),txt_VL2.getValue(),txt_VL3.getValue()]
  if parseFloat(volt[ch-1])> parseFloat(volt_h[ch-1]):
    discard MessageDialog(frame, message=fmt"You are setting a voltage {volt[ch-1]} higher than the limit {volt_h[ch-1]} !", 
          caption="Warning", style=wOK).display()
  elif parseFloat(volt[ch-1])< parseFloat(volt_l[ch-1]):
    discard MessageDialog(frame, message=fmt"You are setting a voltage {volt[ch-1]} lower than the limit {volt_l[ch-1]} !", 
          caption="Warning", style=wOK).display()
  else:
    my_instrument.write(fmt":APPL CH{ch},{volt[ch-1]},{curr[ch-1]}")   

btn_ch1.wEvent_Button do ():
  apply_voltage(1)

btn_ch2.wEvent_Button do ():
  apply_voltage(2) 

btn_ch3.wEvent_Button do ():
  apply_voltage(3) 

frame.center()
frame.show()
app.mainLoop()
