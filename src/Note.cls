VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Note"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private ParentFrame As MSForms.frame
Private WsNote As Worksheet
Private TextBox As Collection
Private CheckBox As Collection
Private CommandButton As Collection
Private NumberElement As Integer

' Cette classe gère la création, mise à jour, suppression et sauvegarde
' des éléments dans la page note

Public Sub AddElement(ByVal row As Integer, Optional ByVal ReadFromFile As Boolean = True)
    Dim NewControl As Object
    Dim defaultText As String
    Dim textSplit() As String
    Dim position1 As Integer
    Dim position2 As Integer
    Dim ws As Worksheet
    Dim lastRow As Integer
    Dim name As String
    Dim firstName As String
    Dim found As Boolean
    
    Dim ClassCheckBox As EventCheckBox
    Dim ClassBoxMatriExist As EventMatriExist
    Dim ClassBoxSelectNote As EventSelectNote
    
    For j = 1 To 6
        Select Case j
            Case 1
                Set NewControl = ParentFrame.Controls.Add("Forms.CommandButton.1", "buttonNote_" & (row - 1), True)
                
                With NewControl
                    .Top = 38 + (row - 2) * 20
                    .Height = 16
                    .Width = 100
                    .Left = 360
                    .Caption = "Voir la notes"
                End With
                
                ' Event selected note
                Set ClassBoxSelectNote = New EventSelectNote
                Set ClassBoxSelectNote.CommandButton = NewControl
                CommandButton.Add ClassBoxSelectNote
                
            Case 6
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
                ClassCheckBox.GroupName = "Note"
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
                        Case 2
                            .Width = 66
                            .Left = 24
                            .MaxLength = 8
                            
                            defaultText = "LAXXXXXX"
                            
                            ' Event verify if abbreviation exist
                            Set ClassBoxMatriExist = New EventMatriExist
                            Set ClassBoxMatriExist.TextBox = NewControl
                            ClassBoxMatriExist.verifyMatriExist
                            TextBox.Add ClassBoxMatriExist
                        Case 3
                            .Width = 78
                            .Left = 96
                            .MaxLength = 16
                            .Locked = True
                            
                            defaultText = "Non-défini"
                        Case 4
                            .Width = 78
                            .Left = 192
                            .MaxLength = 16
                            .Locked = True
                            
                            defaultText = "Non-défini"
                        Case 5
                            .Width = 60
                            .Left = 282
                            .MaxLength = 16
                            
                            defaultText = "Non-défini"
                    End Select
                    
                    If ReadFromFile = True Then
                        Select Case j
                            Case 2
                                Set ws = Worksheets("Etudiants")
                                lastRow = ws.Cells(ws.Rows.count, 1).End(xlUp).row
                                
                                
                                textSplit = Split(Trim(WsNote.Cells(row + 2, "B").value), " ")
                                
                                If (UBound(textSplit) - LBound(textSplit) + 1) >= 2 Then
                                    name = textSplit(0)
                                    
                                    position1 = InStr(textSplit(1), "(")
                                    If position1 > 0 Then
                                        firstName = Left(textSplit(1), position1 - 1)
                                    Else
                                        firstName = textSplit(1)
                                    End If
                                    
                                    found = False
                                    For i = 2 To lastRow
                                        If ws.Cells(i, "B").value = name And ws.Cells(i, "C").value = firstName Then
                                            .text = ws.Cells(i, "A").value
                                            found = True
                                            Exit For
                                        End If
                                    Next i
                                    
                                    If Not found Then
                                        .text = "Inconnue"
                                    End If
                                Else
                                    .text = "Inconnue"
                                End If
                                    
                            Case 3
                                textSplit = Split(Trim(WsNote.Cells(row + 2, "B").value), " ")
                                
                                If (UBound(textSplit) - LBound(textSplit) + 1) >= 2 Then
                                    .text = textSplit(0)
                                Else
                                    .text = "ERREUR"
                                End If
                                
                            Case 4
                                textSplit = Split(Trim(WsNote.Cells(row + 2, "B").value), " ")
                                
                                If (UBound(textSplit) - LBound(textSplit) + 1) >= 2 Then
                                    position1 = InStr(textSplit(1), "(")
                                    If position1 > 0 Then
                                        .text = Left(textSplit(1), position1 - 1)
                                    Else
                                        .text = textSplit(1)
                                    End If
                                Else
                                    .text = "ERREUR"
                                End If
                                
                            Case 5
                                position1 = InStr(Trim(WsNote.Cells(row + 2, "B").value), "(")
                                position2 = InStr(Trim(WsNote.Cells(row + 2, "B").value), ")")
  
                                If position1 > 0 And position2 > position1 Then
                                    .text = Mid(Trim(WsNote.Cells(row + 2, "B").value), position1 + 1, position2 - position1 - 1)
                                Else
                                    .text = "ERREUR"
                                End If
                        End Select
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
    If startIndex < 4 Then startIndex = 4
    
    endIndex = startIndex + 15
    If endIndex > NumberElement + 1 Then endIndex = NumberElement + 1
    
    For i = startIndex To endIndex
        For j = 1 To 6
            Select Case j
                Case 1
                    On Error Resume Next
                        Set control = ParentFrame.Controls("buttonNote_" & (i - 1))
                        control.Top = 38 + (i - 2) * 20 - (ScrollBarValue - 1) * 20
                    On Error GoTo 0
                    
                Case 6
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
    Dim name As String
    Dim firstName As String
    Dim classroom As String
    Dim lastRow As Integer
    
    ' efface avent de remplir
    lastRow = WsNote.Cells(WsNote.Rows.count, 1).End(xlUp).row
    If lastRow >= 2 Then WsNote.Range("A4:B" & lastRow).ClearContents
    
    For i = 1 To NumberElement
        name = ParentFrame.Controls("textBox_" & (i) & "_" & 3).value
        firstName = ParentFrame.Controls("textBox_" & (i) & "_" & 4).value
        classroom = ParentFrame.Controls("textBox_" & (i) & "_" & 5).value
        
        WsNote.Cells(i + 3, "A").value = i
        WsNote.Cells(i + 3, "B").value = name & " " & firstName & " (" & classroom & ")"
    Next i
End Sub

Public Sub TrashElement(ByVal row As Integer)
    Dim control As control
    
    For j = 1 To 6
        Select Case j
            Case 1
                On Error Resume Next
                    ParentFrame.Controls.Remove ("buttonNote_" & row)
                On Error GoTo 0
                
            Case 6
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
        For j = 1 To 6
            Select Case j
                Case 1
                    Set control = ParentFrame.Controls("buttonNote_" & i)
                    control.name = "buttonNote_" & (i - 1)

                Case 6
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

Public Property Set SetWSNote(ByVal Sheet As Worksheet)
    Set WsNote = Sheet
End Property

Public Property Set SetTextBox(ByVal TextBoxCollection As Collection)
    Set TextBox = TextBoxCollection
End Property

Public Property Set SetCheckBox(ByVal CheckBoxCollection As Collection)
    Set CheckBox = CheckBoxCollection
End Property

Public Property Set SetCommandButton(ByVal CommandButtonCollection As Collection)
    Set CommandButton = CommandButtonCollection
End Property

Public Property Let SetNumberElement(ByVal Num As Integer)
    NumberElement = Num
End Property


' Get --------------------------------------------------------------------------------

Public Property Get GetParentFrame() As MSForms.frame
    Set GetParentFrame = ParentFrame
End Property

Public Property Get GetWSNote() As Worksheet
    Set GetWSNote = WsNote
End Property

Public Property Get GetTextBox() As Collection
    Set GetTextBox = TextBox
End Property

Public Property Get GetCheckBox() As Collection
    Set GetCheckBox = CheckBox
End Property

Public Property Get GetCommandButton() As Collection
    Set GetCommandButton = CommandButton
End Property

Public Property Get GetNumberElement() As Integer
    GetNumberElement = NumberElement
End Property

