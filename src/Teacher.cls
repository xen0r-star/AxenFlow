VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Teacher"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private ParentFrame As MSForms.frame
Private WsTeacher As Worksheet
Private TextBox As Collection
Private CheckBox As Collection
Private NumberElement As Integer

' Cette classe gère la création, mise à jour, suppression et sauvegarde
' des éléments dans la page enseignant

Public Sub AddElement(ByVal row As Integer, Optional ByVal ReadFromFile As Boolean = True)
    Dim NewControl As Object
    Dim defaultText As String
    
    Dim ClassBoxAbbr As EventAbbr
    Dim ClassBoxTeacherEmail As EventTeacherEmail
    Dim ClassCheckBox As EventCheckBox

    For j = 1 To 5
        Select Case j
            Case 5
                Set NewControl = ParentFrame.Controls.Add("Forms.CheckBox.1", "checkBox_" & (row - 1), True)
                
                With NewControl
                    .Top = 38 + (row - 2) * 20
                    .Height = 14
                    .Width = 14
                    .Left = 12
                End With
                
                ' Event count selected element
                Set ClassCheckBox = New EventCheckBox
                Set ClassCheckBox.CheckBox = NewControl
                ClassCheckBox.GroupName = "Teacher"
                CheckBox.Add ClassCheckBox
            
            Case Else
                Set NewControl = ParentFrame.Controls.Add("Forms.TextBox.1", "textBox_" & (row - 1) & "_" & j, True)
                
                With NewControl
                    .Top = 38 + (row - 2) * 20
                    .Height = 15
                    .ForeColor = &HFFFFFF
                    .BackColor = &H36381A
                    .BorderStyle = fmBorderStyleSingle
                    .BorderColor = &H36381A
                    .Font.name = "Verdana"
                    .Font.Size = 9
        
                    Select Case j
                        Case 1
                            .Width = 66
                            .Left = 24
                            .MaxLength = 5
                            
                            defaultText = "XXXXX"
            
                            ' event verify abbreviation
                            Set ClassBoxAbbr = New EventAbbr
                            Set ClassBoxAbbr.TextBox = NewControl
                            ClassBoxAbbr.verifyAbbr
                            TextBox.Add ClassBoxAbbr ' Stocke l'instance pour eviter sa destruction
                        Case 2
                            .Width = 120
                            .Left = 102
                            .MaxLength = 19
                            
                            defaultText = "Non-défini"
                        Case 3
                            .Width = 120
                            .Left = 228
                            .MaxLength = 19
                            
                            defaultText = "Non-défini"
                        Case 4
                            .Width = 186
                            .Left = 354
                            .MaxLength = 0
                            
                            defaultText = "prenom.nom@helha.be"
            
                            ' event verify teacher email
                            Set ClassBoxTeacherEmail = New EventTeacherEmail
                            Set ClassBoxTeacherEmail.TextBox = NewControl
                            ClassBoxTeacherEmail.verifyEmailTeacher
                            TextBox.Add ClassBoxTeacherEmail
                    End Select
                    
                    If ReadFromFile = True Then
                        .text = Trim(WsTeacher.Cells(row, j).value)
                    Else
                        .text = defaultText
                        .ForeColor = &HF1E1A0
                    End If
                End With
        End Select
    Next j
End Sub

Public Sub UpdateElement(ByVal ScrollBarValue As Integer)
    Dim control As control
    Dim startIndex As Integer
    Dim endIndex As Integer
    
    
    startIndex = ScrollBarValue
    If startIndex < 2 Then startIndex = 2
    
    endIndex = startIndex + 15
    If endIndex > NumberElement + 1 Then endIndex = NumberElement + 1
    
    For i = startIndex To endIndex
        For j = 1 To 5
            Select Case j
                Case 5
                    On Error Resume Next
                        Set control = ParentFrame.Controls("checkBox_" & (i - 1))
                        control.Top = 38 + (i - 2) * 20 - (ScrollBarValue - 1) * 20
                    On Error GoTo 0
                
                Case Else
                    On Error Resume Next
                        Set control = ParentFrame.Controls("textBox_" & (i - 1) & "_" & j)
                        control.Top = 38 + (i - 2) * 20 - (ScrollBarValue - 1) * 20
                    On Error GoTo 0
            End Select
        Next j
    Next i
End Sub

Public Sub SaveElement()
    Dim value As String
    Dim lastRow As Integer
    
    ' efface avent de remplir
    lastRow = WsTeacher.Cells(WsTeacher.Rows.count, 1).End(xlUp).row
    If lastRow >= 2 Then WsTeacher.Rows("2:" & lastRow).ClearContents
    
    For i = 1 To NumberElement
        For j = 1 To 4
            value = ParentFrame.Controls("textBox_" & (i) & "_" & j).value
            
            WsTeacher.Cells(i + 1, j).value = value
        Next j
    Next i
End Sub

Public Sub TrashElement(ByVal row As Integer)
    Dim control As control
    
    For j = 1 To 5
        Select Case j
            Case 5
                On Error Resume Next
                    ParentFrame.Controls.Remove ("checkBox_" & row)
                On Error GoTo 0

            Case Else
                On Error Resume Next
                    ParentFrame.Controls.Remove ("textBox_" & row & "_" & j)
                On Error GoTo 0
        End Select
    Next j
    
    For i = row + 1 To NumberElement
        For j = 1 To 5
            Select Case j
                Case 5
                    Set control = ParentFrame.Controls("checkBox_" & i)
                    control.name = "checkBox_" & (i - 1)
    
                Case Else
                    Set control = ParentFrame.Controls("textBox_" & i & "_" & j)
                    control.name = "textBox_" & (i - 1) & "_" & j
            End Select
        Next j
    Next i
    
    NumberElement = NumberElement - 1
End Sub

' Set --------------------------------------------------------------------------------

Public Property Set SetParentFrame(ByVal Parent As MSForms.frame)
    Set ParentFrame = Parent
End Property

Public Property Set SetWSTeacher(ByVal Sheet As Worksheet)
    Set WsTeacher = Sheet
End Property

Public Property Set SetTextBox(ByVal TextBoxCollection As Collection)
    Set TextBox = TextBoxCollection
End Property

Public Property Set SetCheckBox(ByVal CheckBoxCollection As Collection)
    Set CheckBox = CheckBoxCollection
End Property

Public Property Let SetNumberElement(ByVal Num As Integer)
    NumberElement = Num
End Property


' Get --------------------------------------------------------------------------------

Public Property Get GetParentFrame() As MSForms.frame
    Set GetParentFrame = ParentFrame
End Property

Public Property Get GetWSTeacher() As Worksheet
    Set GetWSTeacher = WsTeacher
End Property

Public Property Get GetTextBox() As Collection
    Set GetTextBox = TextBox
End Property

Public Property Get GetCheckBox() As Collection
    Set GetCheckBox = CheckBox
End Property

Public Property Get GetNumberElement() As Integer
    GetNumberElement = NumberElement
End Property
