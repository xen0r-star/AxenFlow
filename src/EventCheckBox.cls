VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "EventCheckBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public WithEvents CheckBox As MSForms.CheckBox
Attribute CheckBox.VB_VarHelpID = -1
Public GroupName As String

' Compte le nombre de cases à cocher sélectionnées dans un groupe et
' met à jour l'étiquette du sous-titre avec le nombre sélectionné

Public Sub CheckBox_Click()
    Dim control As MSForms.CheckBox
    Dim count As Integer
    Dim i As Integer
    
    count = 0
    i = 1
    
    Do
        Set control = Nothing
        
        On Error Resume Next
            Set control = Main.Controls(CheckBox.Parent.name).Controls("checkBox_" & i)
        On Error GoTo 0
        
        If control Is Nothing Then Exit Do
        
        If control.value = True Then
            count = count + 1
        End If
        
        i = i + 1
    Loop
    
    Main.Controls("Frame" & GroupName & "Header").Controls("Label" & GroupName & "Subtitle").Caption = CStr(count) & " sélectionné"
End Sub
