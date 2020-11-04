import wNim/[wApp, wFrame,wPanel]
import ../src/RIGOL_DP832/wRsrcCtrl


let app = App()
let frame = Frame(title="VISA Resource Control")
var panel = Panel(frame)
var rstr = RsrcCtrl(panel)

echo rstr.getValue()

frame.center()
frame.show()
app.mainLoop()
