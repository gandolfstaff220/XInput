VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsXInput"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Const XINPUT_DEVTYPE_GAMEPAD As Long = &H0
Private Declare Function apiXInputGetState Lib "XInput1_4" Alias "XInputGetState" (ByVal dwUserIndex As Long, ByRef pState As XINPUT_STATE) As Long
Private Declare Function apiXInputGetBatteryInformation Lib "XInput1_4" Alias "XInputGetBatteryInformation" (ByVal dwUserIndex As Long, ByVal devType As Byte, ByRef pBatteryInformation As XINPUT_BATTERY_INFORMATION) As Long
Private Declare Function apiXInputEnable Lib "XInput1_4" Alias "XInputEnable" (ByVal Enable As Long) As Long
Private Declare Function apiCopyMemoryType Lib "kernel32" Alias "RtlMoveMemory" (ByRef lpDest As XINPUT_STATE, ByRef lpSource As XINPUT_STATE, ByVal cbCopy As Long) As Long
Private WithEvents tmrInputState As Timer
Attribute tmrInputState.VB_VarHelpID = -1
Public Event OnButtonADown()
Public Event OnButtonAUp()
Public Event OnButtonBDown()
Public Event OnButtonBUp()
Public Event OnButtonXDown()
Public Event OnButtonXUp()
Public Event OnButtonYDown()
Public Event OnButtonYUp()
Public Event OnButtonUpDown()
Public Event OnButtonUpUp()
Public Event OnButtonDownDown()
Public Event OnButtonDownUp()
Public Event OnButtonLeftDown()
Public Event OnButtonLeftUp()
Public Event OnButtonRightDown()
Public Event OnButtonRightUp()
Public Event OnButtonLSHDown()
Public Event OnButtonLSHUp()
Public Event OnButtonRSHDown()
Public Event OnButtonRSHUp()
Public Event OnButtonLSDown()
Public Event OnButtonLSUp()
Public Event OnButtonRSDown()
Public Event OnButtonRSUp()
Public Event OnButtonBackDown()
Public Event OnButtonBackUp()
Public Event OnButtonStartDown()
Public Event OnButtonStartUp()
Public Event OnDeviceConnected()
Public Event OnDeviceDisconnected()
Public Event OnLThumbChange(ByVal x As Double, ByVal y As Double)
Public Event OnRThumbChange(ByVal x As Double, ByVal y As Double)
Public Event OnLTriggerChange(ByVal z As Long)
Public Event OnRTriggerChange(ByVal z As Long)
Private IsButtonADown     As Boolean
Private IsButtonBDown     As Boolean
Private IsButtonXDown     As Boolean
Private IsButtonYDown     As Boolean
Private IsButtonUpDown    As Boolean
Private IsButtonDownDown  As Boolean
Private IsButtonLeftDown  As Boolean
Private IsButtonRightDown As Boolean
Private IsButtonLSHDown   As Boolean
Private IsButtonRSHDown   As Boolean
Private IsButtonLSDown    As Boolean
Private IsButtonRSDown    As Boolean
Private IsButtonBackDown  As Boolean
Private IsButtonStartDown As Boolean
Private xinputconnected   As Boolean
Private Type XINPUT_BATTERY_INFORMATION
    BatteryType As Byte
    BatteryLevel As Byte
End Type
Private Enum BATTERY_TYPE_
    Disconnected = &H0
    Wired = &H1
    Alkaline = &H2
    Rechargeable = &H3
    Charging = &HFF
End Enum
Private Enum BATTERY_LEVEL_
    Dead = &H0
    Low = &H1
    Good = &H2
    Full = &H3
End Enum
Private Enum XINPUT_GAMEPAD_
    DPAD_UP = &H1
    DPAD_DOWN = &H2
    DPAD_LEFT = &H4
    DPAD_RIGHT = &H8
    Start = &H10
    Back = &H20
    LEFT_THUMB = &H40
    RIGHT_THUMB = &H80
    LEFT_SHOULDER = &H100
    RIGHT_SHOULDER = &H200
    a = &H1000
    B = &H2000
    x = &H4000
    y = &H8000
    LEFT_THUMBx = -1
    LEFT_THUMBy = -2
    RIGHT_THUMBx = -3
    RIGHT_THUMBY = -4
    LEFT_TRIGGER = -5
    RIGHT_TRIGGER = -6
    BIG_BUTTON = 1024
End Enum
Private Sub Class_Initialize()
    Set tmrInputState = New Timer
    tmrInputState.Interval = 1
    tmrInputState.Enabled = True
End Sub
Public Sub DeviceConnected()
    RaiseEvent OnDeviceConnected
End Sub
Public Sub DeviceDisconnected()
    RaiseEvent OnDeviceDisconnected
End Sub
Public Sub ButtonADown()
    RaiseEvent OnButtonADown
End Sub
Public Sub ButtonAUp()
    RaiseEvent OnButtonAUp
End Sub
Public Sub ButtonBDown()
    RaiseEvent OnButtonBDown
End Sub
Public Sub ButtonBUp()
    RaiseEvent OnButtonBUp
End Sub
Public Sub ButtonXDown()
    RaiseEvent OnButtonXDown
End Sub
Public Sub ButtonXUp()
    RaiseEvent OnButtonXUp
End Sub
Public Sub ButtonYDown()
    RaiseEvent OnButtonYDown
End Sub
Public Sub ButtonYUp()
    RaiseEvent OnButtonYUp
End Sub
Public Sub ButtonUpDown()
    RaiseEvent OnButtonUpDown
End Sub
Public Sub ButtonUpUp()
    RaiseEvent OnButtonUpUp
End Sub
Public Sub ButtonDownDown()
    RaiseEvent OnButtonDownDown
End Sub
Public Sub ButtonDownUp()
    RaiseEvent OnButtonDownUp
End Sub
Public Sub ButtonLeftDown()
    RaiseEvent OnButtonLeftDown
End Sub
Public Sub ButtonLeftUp()
    RaiseEvent OnButtonLeftUp
End Sub
Public Sub ButtonRightDown()
    RaiseEvent OnButtonRightDown
End Sub
Public Sub ButtonRightUp()
    RaiseEvent OnButtonRightUp
End Sub
Public Sub ButtonLSHDown()
    RaiseEvent OnButtonLSHDown
End Sub
Public Sub ButtonLSHUp()
    RaiseEvent OnButtonLSHUp
End Sub
Public Sub ButtonRSHDown()
    RaiseEvent OnButtonRSHDown
End Sub
Public Sub ButtonRSHUp()
    RaiseEvent OnButtonRSHUp
End Sub
Public Sub ButtonLSDown()
    RaiseEvent OnButtonLSDown
End Sub
Public Sub ButtonLSUp()
    RaiseEvent OnButtonLSUp
End Sub
Public Sub ButtonRSDown()
    RaiseEvent OnButtonRSDown
End Sub
Public Sub ButtonRSUp()
    RaiseEvent OnButtonRSUp
End Sub
Public Sub ButtonBackDown()
    RaiseEvent OnButtonBackDown
End Sub
Public Sub ButtonBackUp()
    RaiseEvent OnButtonBackUp
End Sub
Public Sub ButtonStartDown()
    RaiseEvent OnButtonStartDown
End Sub
Public Sub ButtonStartUp()
    RaiseEvent OnButtonStartUp
End Sub
Public Sub LThumbChange(ByVal x As Double, ByVal y As Double)
    RaiseEvent OnLThumbChange(x, y)
End Sub
Public Sub RThumbChange(ByVal x As Double, ByVal y As Double)
    RaiseEvent OnRThumbChange(x, y)
End Sub
Public Sub LTriggerChange(ByVal z As Long)
    RaiseEvent OnLTriggerChange(z)
End Sub
Public Sub RTriggerChange(ByVal z As Long)
    RaiseEvent OnRTriggerChange(z)
End Sub
Friend Sub Enable()
    On Error Resume Next
    apiXInputEnable 1
End Sub
Friend Sub Disable()
    On Error Resume Next
    apiXInputEnable 0
End Sub
Friend Function GetState(ByVal dwUserIndex As Long, ByRef pState As XINPUT_STATE) As Long
    On Error Resume Next
    Dim ret As Long
    ret = ERROR_DEVICE_NOT_CONNECTED
    ret = apiXInputGetState(dwUserIndex, pState)
    GetState = ret
End Function
Private Sub tmrInputState_Elapsed()
    On Error Resume Next
    Dim xis As XINPUT_STATE
    Dim ret As Long
    ret = ERROR_DEVICE_NOT_CONNECTED
    ret = GetState(0, xis)
    If ret = ERROR_DEVICE_NOT_CONNECTED Then
        If xinputconnected = True Then 'if we were connected
            xinputconnected = False 'now we are not
            DeviceDisconnected 'signal event outward
        End If
    ElseIf ret = ERROR_EMPTY Then 'no input change since last called
        If xinputconnected = False Then
            xinputconnected = True
            DeviceConnected
        End If
    ElseIf ret = ERROR_SUCCESS Then 'new input
        If xinputconnected = False Then 'if we were not connected
            xinputconnected = True 'now we are
            DeviceConnected 'signal event outward
        End If
        'if left stick has moved since last input state change, signal new axis coords outward
        If xis.Gamepad.sThumbLX <> oldis.Gamepad.sThumbLX Or xis.Gamepad.sThumbLY <> oldis.Gamepad.sThumbLY Then
            LThumbChange xis.Gamepad.sThumbLX, xis.Gamepad.sThumbLY 'signal event
        End If
        If xis.Gamepad.sThumbRX <> oldis.Gamepad.sThumbRX Or xis.Gamepad.sThumbRY <> oldis.Gamepad.sThumbRY Then 'If right stick moved
            RThumbChange xis.Gamepad.sThumbRX, xis.Gamepad.sThumbRY 'signal event
        End If
        If xis.Gamepad.bLeftTrigger <> oldis.Gamepad.bLeftTrigger Then 'If left trigger changed
            LTriggerChange xis.Gamepad.bLeftTrigger 'signal event
        End If
        If xis.Gamepad.bRightTrigger <> oldis.Gamepad.bRightTrigger Then 'If right trigger changed
            RTriggerChange xis.Gamepad.bRightTrigger 'signal event
        End If
        apiCopyMemoryType oldis, xis, Len(xis) 'faster?' oldis = xis
        If IsButtonADown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.a) = XINPUT_GAMEPAD_.a Then
                IsButtonADown = True
                ButtonADown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.a) <> XINPUT_GAMEPAD_.a Then
                IsButtonADown = False
                ButtonAUp
            End If
        End If
        If IsButtonBDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.B) = XINPUT_GAMEPAD_.B Then
                IsButtonBDown = True
                ButtonBDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.B) <> XINPUT_GAMEPAD_.B Then
                IsButtonBDown = False
                ButtonBUp
            End If
        End If
        If IsButtonXDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.x) = XINPUT_GAMEPAD_.x Then
                IsButtonXDown = True
                ButtonXDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.x) <> XINPUT_GAMEPAD_.x Then
                IsButtonXDown = False
                ButtonXUp
            End If
        End If
        If IsButtonYDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.y) = XINPUT_GAMEPAD_.y Then
                IsButtonYDown = True
                ButtonYDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.y) <> XINPUT_GAMEPAD_.y Then
                IsButtonYDown = False
                ButtonYUp
            End If
        End If
        If IsButtonUpDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.DPAD_UP) = XINPUT_GAMEPAD_.DPAD_UP Then
                IsButtonUpDown = True
                ButtonUpDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.DPAD_UP) <> XINPUT_GAMEPAD_.DPAD_UP Then
                IsButtonUpDown = False
                ButtonUpUp
            End If
        End If
        If IsButtonDownDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.DPAD_DOWN) = XINPUT_GAMEPAD_.DPAD_DOWN Then
                IsButtonDownDown = True
                ButtonDownDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.DPAD_DOWN) <> XINPUT_GAMEPAD_.DPAD_DOWN Then
                IsButtonDownDown = False
                ButtonDownUp
            End If
        End If
        If IsButtonLeftDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.DPAD_LEFT) = XINPUT_GAMEPAD_.DPAD_LEFT Then
                IsButtonLeftDown = True
                ButtonLeftDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.DPAD_LEFT) <> XINPUT_GAMEPAD_.DPAD_LEFT Then
                IsButtonLeftDown = False
                ButtonLeftUp
            End If
        End If
        If IsButtonRightDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.DPAD_RIGHT) = XINPUT_GAMEPAD_.DPAD_RIGHT Then
                IsButtonRightDown = True
                ButtonRightDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.DPAD_RIGHT) <> XINPUT_GAMEPAD_.DPAD_RIGHT Then
                IsButtonRightDown = False
                ButtonRightUp
            End If
        End If
        If IsButtonLSHDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.LEFT_SHOULDER) = XINPUT_GAMEPAD_.LEFT_SHOULDER Then
                IsButtonLSHDown = True
                ButtonLSHDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.LEFT_SHOULDER) <> XINPUT_GAMEPAD_.LEFT_SHOULDER Then
                IsButtonLSHDown = False
                ButtonLSHUp
            End If
        End If
        If IsButtonRSHDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.RIGHT_SHOULDER) = XINPUT_GAMEPAD_.RIGHT_SHOULDER Then
                IsButtonRSHDown = True
                ButtonRSHDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.RIGHT_SHOULDER) <> XINPUT_GAMEPAD_.RIGHT_SHOULDER Then
                IsButtonRSHDown = False
                ButtonRSHUp
            End If
        End If
        If IsButtonLSDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.LEFT_THUMB) = XINPUT_GAMEPAD_.LEFT_THUMB Then
                IsButtonLSDown = True
                ButtonLSDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.LEFT_THUMB) <> XINPUT_GAMEPAD_.LEFT_THUMB Then
                IsButtonLSDown = False
                ButtonLSUp
            End If
        End If
        If IsButtonRSDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.RIGHT_THUMB) = XINPUT_GAMEPAD_.RIGHT_THUMB Then
                IsButtonRSDown = True
                ButtonRSDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.RIGHT_THUMB) <> XINPUT_GAMEPAD_.RIGHT_THUMB Then
                IsButtonRSDown = False
                ButtonRSUp
            End If
        End If
        If IsButtonBackDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.Back) = XINPUT_GAMEPAD_.Back Then
                IsButtonBackDown = True
                ButtonBackDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.Back) <> XINPUT_GAMEPAD_.Back Then
                IsButtonBackDown = False
                ButtonBackUp
            End If
        End If
        If IsButtonStartDown = False Then
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.Start) = XINPUT_GAMEPAD_.Start Then
                IsButtonStartDown = True
                ButtonStartDown
            End If
        Else
            If (xis.Gamepad.wButtons And XINPUT_GAMEPAD_.Start) <> XINPUT_GAMEPAD_.Start Then
                IsButtonStartDown = False
                ButtonStartUp
            End If
        End If
    End If
End Sub
Friend Function BatteryLevel(ByVal user As Long) As String
    On Error Resume Next
    Dim bi  As XINPUT_BATTERY_INFORMATION
    Dim ret As Long
    ret = ERROR_DEVICE_NOT_CONNECTED
    ret = apiXInputGetBatteryInformation(user, XINPUT_DEVTYPE_GAMEPAD, bi)
    If ret = ERROR_SUCCESS Then
        Select Case bi.BatteryType
            Case BATTERY_TYPE_.Disconnected
                BatteryLevel = "Estimating"
            Case BATTERY_TYPE_.Wired
                BatteryLevel = "Wired"
            Case BATTERY_TYPE_.Alkaline
                BatteryLevel = "Alkaline"
            Case BATTERY_TYPE_.Rechargeable
                BatteryLevel = "Rechargeable"
            Case BATTERY_TYPE_.Charging
                BatteryLevel = "Charging"
        End Select
        Select Case bi.BatteryLevel
            Case BATTERY_LEVEL_.Dead
                BatteryLevel = BatteryLevel & " Dead"
            Case BATTERY_LEVEL_.Low
                BatteryLevel = BatteryLevel & " Low"
            Case BATTERY_LEVEL_.Good
                BatteryLevel = BatteryLevel & " Good"
            Case BATTERY_LEVEL_.Full
                BatteryLevel = BatteryLevel & " Full"
        End Select
    End If
End Function
Friend Sub Class_Terminate()
    tmrInputState.Enabled = False
    Set tmrInputState = Nothing
End Sub
'
'If CompareInputStates(xis, oldis) = False Then'Not needed?  success means that there was new input returned
'Private Function CompareInputStates(a As XINPUT_STATE, B As XINPUT_STATE) As Boolean
'    On Error Resume Next
'    Dim i         As Integer
'    Dim abytes()  As Byte
'    Dim bbytes()  As Byte
'    Dim different As Boolean
'    ReDim abytes(1 To LenB(a))
'    ReDim bbytes(1 To LenB(B))
'    apiCopyMemory abytes(1), a, Len(a)
'    apiCopyMemory bbytes(1), B, Len(B)
'    For i = 1 To LenB(a)
'        If abytes(i) <> bbytes(i) Then
'            CompareInputStates = False
'            Exit Function
'        End If
'    Next
'    CompareInputStates = True
'End Function
'Private Type XINPUT_VIBRATION
'    wLeftMotorSpeed As Integer
'    wRightMotorSpeed As Integer
'End Type
'Private Type XINPUT_CAPABILITIES
'    Typ As Byte
'    SubType As Byte
'    Flags As Integer
'    Gamepad As XINPUT_GAMEPAD
'    Vibration As XINPUT_VIBRATION
'End Type
'Private Type XINPUT_BATTERY_INFORMATION
'    BatteryType As Byte
'    BatteryLevel As Byte
'End Type
'Private Type XINPUT_KEYSTROKE
'    VirtualKey As Integer
'    Unicode As Variant
'    Flags As Integer
'    UserIndex As Byte
'    HidCode As Byte
'End Type
'Private Type VIBRATIONPARAMS
'    dwMilliseconds As Long
'    Left As Integer
'    Right As Integer
'    user As Long
'End Type
'Private Type XINPUT_BUTTON_STATE
'    a As Boolean
'    B As Boolean
'    x As Boolean
'    y As Boolean
'    DPAD_UP As Boolean
'    DPAD_DOWN As Boolean
'    DPAD_LEFT As Boolean
'    DPAD_RIGHT As Boolean
'    DPAD_UP_RIGHT As Boolean
'    DPAD_UP_LEFT As Boolean
'    DPAD_DOWN_RIGHT As Boolean
'    DPAD_DOWN_LEFT As Boolean
'    LEFT_SHOULDER As Boolean
'    RIGHT_SHOULDER As Boolean
'    Start As Boolean
'    Back As Boolean
'    bLeftTrigger As Byte
'    bRightTrigger As Byte
'    sThumbLX As Integer
'    sThumbLY As Integer
'    sThumbRX As Integer
'    sThumbRY As Integer
'    LEFT_THUMB As Boolean
'    RIGHT_THUMB As Boolean
'    BIG_BUTTON As Boolean
'End Type
'Private Type XINPUT_KEYSTROKE
'    VirtualKey As Integer
'    Unicode As Variant
'    Flags As Integer
'    UserIndex As Byte
'    HidCode As Byte
'End Type
'Private Enum XINPUT_GAMEPAD_
'    DPAD_UP = &H1
'    DPAD_DOWN = &H2
'    DPAD_LEFT = &H4
'    DPAD_RIGHT = &H8
'    Start = &H10
'    Back = &H20
'    LEFT_THUMB = &H40
'    RIGHT_THUMB = &H80
'    LEFT_SHOULDER = &H100
'    RIGHT_SHOULDER = &H200
'    a = &H1000
'    B = &H2000
'    x = &H4000
'    y = &H8000
'    LEFT_THUMBx = -1
'    LEFT_THUMBy = -2
'    RIGHT_THUMBx = -3
'    RIGHT_THUMBY = -4
'    LEFT_TRIGGER = -5
'    RIGHT_TRIGGER = -6
'    BIG_BUTTON = 1024
'End Enum
'Private Const XINPUT_DEVSUBTYPE_GAMEPAD           As Long = &H1
'Private Const XINPUT_GAMEPAD_LEFT_THUMB_DEADZONE  As Long = 7849
'Private Const XINPUT_GAMEPAD_RIGHT_THUMB_DEADZONE As Long = 8689
'Private Const XINPUT_GAMEPAD_TRIGGER_THRESHOLD    As Long = 30
'Private Const XINPUT_FLAG_GAMEPAD                 As Long = &H1
'Private Const XUSER_INDEX_ANY                     As Long = &HFF
'Private Const XUSER_MAX_COUNT                     As Long = 8
'Private Declare Function apiXInputSetState Lib "XInput1_4" Alias "XInputSetState" (ByVal dwUserIndex As Long, ByRef vState As XINPUT_VIBRATION) As Long
'Private Declare Function apiXInputGetKeyStroke Lib "XInput1_4" Alias "XInputGetKeystroke" (ByVal dwUserIndex As Long, ByVal dwReserved As Long, ByRef XinputKeystroke As XINPUT_KEYSTROKE) As Integer
'Private Declare Function apiXInputGetCapabilities Lib "XInput1_4" Alias "XInputGetCapabilities" (ByVal dwUserIndex As Long, ByVal dwFlags As Long, ByRef pCapabilities As XINPUT_CAPABILITIES) As Long
'Public Enum BATTERY_DEVTYPE_
'    Gamepad = &H0
'    HEADSET = &H1
'End Enum
'Public Type VIBRATIONPARAMS
'    dwMilliseconds As Long
'    Left As Integer
'    Right As Integer
'    user As Long
'End Type
'Public Type XINPUT_VIBRATION
'    wLeftMotorSpeed As Integer
'    wRightMotorSpeed As Integer
'End Type
'Public Type XINPUT_CAPABILITIES
'    Typ As Byte
'    SubType As Byte
'    Flags As Integer
'    Gamepad As XINPUT_GAMEPAD
'    Vibration As XINPUT_VIBRATION
'End Type
