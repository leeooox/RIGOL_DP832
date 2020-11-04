import nimvisa
import wNim/wComboBox
import wNim/private/wBase
import wNim/private/controls/wControl
#import  wNim/[wApp, wFrame,wIcon, wStatusBar, wMenuBar, wMenu, wBitmap, wImage, wPanel]

#proc RefreshAddr() :void

type
  wRsrcCtrl* = ref object of wComboBox


proc final*(self: wRsrcCtrl) =
  ## Default finalizer for wZeeGrid.
  discard
proc init*(self: wRsrcCtrl, parent: wWindow, id = wDefaultID, 
    pos = wDefaultPoint, size = wDefaultSize, style = wCbDropDown or wCbReadOnly) {.validate.} =
  ## Initializer.
  wValidate(parent)
  self.wComboBox.init(parent=parent, id=id, pos=pos, size=size, style=style)
  var rm = newResourceManager()
  var instr_seq = rm.list_resources() 
  self.wComboBox.append(instr_seq)
  self.wComboBox.append("Refresh")
  self.wComboBox.select(0)
  self.wComboBox.setSize(size=(300,23))

  self.wComboBox.wEvent_ComboBox do (event: wEvent):
    var ctrl = wComboBox(event.getEventObject())
    if ctrl.getValue() == "Refresh":
      rm = newResourceManager()
      instr_seq = rm.list_resources()
      self.wComboBox.clear()
      self.wComboBox.append(instr_seq)
      self.wComboBox.append("Refresh")
      self.wComboBox.select(0)


proc RsrcCtrl*(parent: wWindow, id = wDefaultID, pos = wDefaultPoint, 
    size = wDefaultSize, style =  wCbDropDown or wCbReadOnly): wRsrcCtrl {.inline, discardable.} =
  ## Constructor, creating and showing a zeegrid control.
  wValidate(parent)
  new(result, final)
  result.init(parent, id, pos, size, style)

proc getValue*(self: wRsrcCtrl) : string =
  result = self.wComboBox.getValue()

#[ 
if isMainModule:
  
  let app = App()
  let frame = Frame(title="VISA Resource Control")
  var panel = Panel(frame)

  var rstr = RsrcCtrl(panel)

  echo rstr.getValue()


  frame.center()
  frame.show()
  app.mainLoop() ]#
