VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Mission"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private ParentFrame As MSForms.frame
Private WsMission As Worksheet
Private TextBox As Collection
Private CheckBox As Collection
Private NumberElement As Integer

' Cette classe gère la création, mise à jour, suppression et sauvegarde
' des éléments dans la page mission

Public Sub AddElement(ByVal row As Integer, Optional ByVal ReadFromFile As Boolean = True)
    Dim NewControl As Object
    Dim defaultText As String
    
    Dim ClassCheckBox As EventCheckBox
    Dim ClassBoxAbbrExist As EventAbbrExist
    
    For j = 1 To 6
        Select Case j
            Case 1
                Set NewControl = ParentFrame.Controls.Add("Forms.ComboBox.1", "comboBox_" & (row - 1) & "_" & j, True)
                
                With NewControl
                    .AddItem "Informatique"
                    .AddItem "Comptabilité"
                    .AddItem "Assistant de direction"
                    .AddItem "Non-défini"
        
                    If ReadFromFile = True Then
                        Select Case Trim(WsMission.Cells(row, j).value)
                            Case "ID": .ListIndex = 0
                            Case "CT": .ListIndex = 1
                            Case "AD": .ListIndex = 2
                            Case Else: .ListIndex = 3
                        End Select
                    
                    Else
                        .ListIndex = 3
                    End If
                    
                    .Top = 38 + (row - 2) * 20
                    .Height = 18
                    .Width = 120
                    .Left = 270
                    
                    .BackColor = &H36381A
                    .BorderStyle = fmBorderStyleSingle
                    .BorderColor = &H36381A
                    .ForeColor = &HFFFFFF
                    .Font.name = "Verdana"
                    .Font.Size = 9
                    .MaxLength = 8
                    .ListStyle = fmListStylePlain
                End With
            
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
                ClassCheckBox.GroupName = "Mission"
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
                            .MaxLength = 5
                            
                            defaultText = "XXXXX"
                            
                            ' Event verify if abbreviation exist
                            Set ClassBoxAbbrExist = New EventAbbrExist
                            Set ClassBoxAbbrExist.TextBox = NewControl
                            ClassBoxAbbrExist.verifyAbbrExist
                            TextBox.Add ClassBoxAbbrExist
                        Case 3
                            .Width = 132
                            .Left = 396
                            .MaxLength = 64
                            
                            defaultText = "Aucune mission"
                        Case 4
                            .Width = 78
                            .Left = 102
                            .MaxLength = 16
                            .Locked = True
                            
                            defaultText = "Non-défini"
                        Case 5
                            .Width = 78
                            .Left = 186
                            .MaxLength = 16
                            .Locked = True
                            
                            defaultText = "Non-défini"
                    End Select
                    
                    If ReadFromFile = True Then
                        Select Case j
                            Case 4
                                On Error Resume Next
                                    nameByMatricule = Application.WorksheetFunction.VLookup(WsMission.Cells(row, 2).value, ThisWorkbook.Sheets("Enseignants").Range("A:C"), 2, False)
                                On Error GoTo 0
                                
                                If nameByMatricule = "" Then
                                    .text = "Inconnue"
                                Else
                                    .text = nameByMatricule
                                End If
                            Case 5
                                On Error Resume Next
                                    firstNameByMatricule = Application.WorksheetFunction.VLookup(WsMission.Cells(row, 2).value, ThisWorkbook.Sheets("Enseignants").Range("A:C"), 3, False)
                                On Error GoTo 0
                                
                                If firstNameByMatricule = "" Then
                                    .text = "Inconnue"
                                Else
                                    .text = firstNameByMatricule
                                End If
                            Case Else
                                .text = Trim(WsMission.Cells(row, j).value)
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
    If startIndex < 2 Then startIndex = 2
    
    endIndex = startIndex + 15
    If endIndex > NumberElement + 1 Then endIndex = NumberElement + 1
    
    For i = startIndex To endIndex
        For j = 1 To 6
            Select Case j
                Case 1
                    On Error Resume Next
                        Set control = ParentFrame.Controls("comboBox_" & (i - 1) & "_" & j)
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
    Dim value As String
    Dim lastRow As Integer
    
    ' efface avent de remplir
    lastRow = WsMission.Cells(WsMission.Rows.count, 1).End(xlUp).row
    If lastRow >= 2 Then WsMission.Rows("2:" & lastRow).ClearContents
    
    For i = 1 To NumberElement
        For j = 1 To 3
            Select Case j
                Case 1
                    Select Case ParentFrame.Controls("comboBox_" & (i) & "_" & j).value
                        Case "Informatique": value = "ID"
                        Case "Comptabilité": value = "CT"
                        Case "Assistant de direction": value = "AD"
                        Case Else: value = ""
                    End Select
                    
                Case Else
                    value = ParentFrame.Controls("textBox_" & (i) & "_" & j).value
            End Select
            
            WsMission.Cells(i + 1, j).value = value
        Next j
    Next i
End Sub

Public Sub TrashElement(ByVal row As Integer)
    Dim control As control
    
    For j = 1 To 6
        Select Case j
            Case 1
                On Error Resume Next
                    ParentFrame.Controls.Remove ("comboBox_" & row & "_" & j)
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
                    Set control = ParentFrame.Controls("comboBox_" & i & "_" & j)
                    control.name = "comboBox_" & (i - 1) & "_" & j

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

Public Property Set SetWSMission(ByVal Sheet As Worksheet)
    Set WsMission = Sheet
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

Public Property Get GetWSMission() As Worksheet
    Set GetWSMission = WsMission
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
