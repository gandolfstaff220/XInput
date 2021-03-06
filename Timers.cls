VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Timers"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public Event TimerEvent(ByVal index As Integer)
Private mCount    As Integer
Private mCol      As New Collection
Private mClassKey As Integer
Private mvarTimer As Timer
Private Sub Class_Initialize()
    mClassKey = RegisterTimerCollection(Me)
    Set mvarTimer = New Timer
End Sub
Friend Sub Class_Terminate()
    On Error Resume Next
    Set mvarTimer = Nothing
    Dim t As Timer
    For Each t In mCol
        Set t = Nothing
    Next
    Set mCol = Nothing
    CTimersCol.Remove "key:" & mClassKey
End Sub
Public Property Get Timer() As Timer
    Set Timer = mvarTimer
End Property
Public Property Set Timer(vData As Timer)
    Set mvarTimer = vData
End Property
Property Get Count() As Integer
    Count = mCount
End Property
Function Add() As Integer
    Dim t As New Timer
    mCount = mCount + 1
    t.index = mCount
    t.ParentsColKey = mClassKey
    mCol.Add t
    Add = mCount
End Function
Public Function BulkLoad(num As Integer)
    Dim i As Long
    If num > 0 And num < 200 Then
        For i = 0 To num
            Add
        Next
    Else
        Err.Raise vbObjectError, "CTimers.BulkLoad", "No more than 200 times allowed per class"
    End If
End Function
Public Function Item(ByVal index As Integer) As Timer
    If index > Count Then Err.Raise vbObjectError, "CTimers.Item", "Index does not Exist"
    Set Item = mCol(index)
End Function
Friend Function RaiseTimer_Event(ByVal index As Integer)
    RaiseEvent TimerEvent(index)
End Function
