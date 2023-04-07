#tag Class
Protected Class XojoUnitBenchmarks
Inherits TestGroup
	#tag DelegateDeclaration, Flags = &h21
		Private Delegate Function RepeatDelegate(s As String, repetitions As Integer) As String
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Sub RepeatTest()
		  Const kRepetitions As Integer = 160
		  Const kString As String = "aa"
		  Const kExpected As String = _
		  "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" + _
		  "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" + _
		  "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" + _
		  "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
		  
		  Assert.Message "Repeat '" + kString + "' " + kRepetitions.ToString("#,##0") + " times"
		  Assert.Message ""
		  
		  Var result As String
		  
		  Var tests() As Pair = Array( _
		  "Array Add" : AddressOf Repeat_ArrayAdd, _
		  "Array Fill" : AddressOf Repeat_ArrayFill, _
		  "Array Join" : AddressOf Repeat_ArrayJoin, _
		  "Concat" : AddressOf Repeat_Concat, _
		  "Doubler" : AddressOf Repeat_Doubler, _
		  "Doubler (MB)" : AddressOf Repeat_DoublerMB _
		  )
		  
		  For Each test As Pair In tests
		    Var testName As String = test.Left
		    Var repeater As RepeatDelegate = test.Right
		    
		    Bench.Start testName
		    While Bench.N > 0
		      result = repeater.Invoke(kString, kRepetitions)
		    Wend
		    
		    Assert.AreEqual kExpected, result, testName
		  Next
		  
		  'Var testName As String
		  '
		  'testName = "Concat"
		  'Bench.Start testName
		  'While Bench.N > 0
		  'result = ""
		  '
		  'While result.Length < kRepetitions
		  'result = result + kString
		  'Wend
		  'Wend
		  'Assert.AreEqual kExpected, result, testName
		  '
		  'testName = "Array Add"
		  'Bench.Start testName
		  'While Bench.N > 0
		  'result = ""
		  '
		  'Var arr() As String
		  'For i As Integer = 1 to kRepetitions
		  'arr.Add kString
		  'Next
		  '
		  'result = String.FromArray(arr, "")
		  'Wend
		  'Assert.AreEqual kExpected, result, testName
		  '
		  'testName = "Array Fill"
		  'Bench.Start testName
		  'While Bench.N > 0
		  'result = ""
		  '
		  'Var lastIndex As Integer = kRepetitions - 1
		  '
		  'Var arr() As String
		  'arr.ResizeTo lastIndex
		  '
		  'For i As Integer = 0 to lastIndex
		  'arr(i) = kString
		  'Next
		  '
		  'result = String.FromArray(arr, "")
		  'Wend
		  'Assert.AreEqual kExpected, result, testName
		  '
		  'testName = "Array Join"
		  'Bench.Start testName
		  'While Bench.N > 0
		  'result = Repeat_ArrayJoin(kString, kRepetitions)
		  'Wend
		  'Assert.AreEqual kExpected, result, testName
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Repeat_ArrayAdd(s As String, repetitions As Integer) As String
		  #If Not DebugBuild Then
		    #Pragma BackgroundTasks False
		    #Pragma BoundsChecking False
		    #Pragma NilObjectChecking False
		    #Pragma StackOverflowChecking False
		  #EndIf
		  
		  Var arr() As String
		  
		  For i As Integer = 1 to repetitions
		    arr.Add(s)
		  Next
		  
		  Return String.FromArray(arr, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Repeat_ArrayFill(s As String, repetitions As Integer) As String
		  #If Not DebugBuild Then
		    #Pragma BackgroundTasks False
		    #Pragma BoundsChecking False
		    #Pragma NilObjectChecking False
		    #Pragma StackOverflowChecking False
		  #EndIf
		  
		  Var lastIndex As Integer = repetitions - 1
		  
		  Var arr() As String
		  arr.ResizeTo lastIndex
		  
		  For i As Integer = 0 To lastIndex
		    arr(i) = s
		  Next
		  
		  Return String.FromArray(arr, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Repeat_ArrayJoin(s As String, repetitions As Integer) As String
		  #If Not DebugBuild Then
		    #Pragma BackgroundTasks False
		    #Pragma BoundsChecking False
		    #Pragma NilObjectChecking False
		    #Pragma StackOverflowChecking False
		  #EndIf
		  
		  Var arr() As String
		  arr.ResizeTo repetitions
		  Return String.FromArray(arr, s)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Repeat_Concat(s As String, repetitions As Integer) As String
		  #If Not DebugBuild Then
		    #Pragma BackgroundTasks False
		    #Pragma BoundsChecking False
		    #Pragma NilObjectChecking False
		    #Pragma StackOverflowChecking False
		  #EndIf
		  
		  Var result As String
		  Var targetLength As Integer = s.Length * repetitions
		  
		  While result.Length < targetLength
		    result = result + s
		  Wend
		  
		  Return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Repeat_Doubler(s As String, repetitions As Integer) As String
		  #If Not DebugBuild Then
		    #Pragma BackgroundTasks False
		    #Pragma BoundsChecking False
		    #Pragma NilObjectChecking False
		    #Pragma StackOverflowChecking False
		  #EndIf
		  
		  Var result As String = s
		  
		  Var currentLength As Integer = result.Bytes
		  Var targetLength As Integer = currentLength * repetitions
		  Var halfLength As Integer = (targetLength + 1) \ 2
		  
		  While currentLength < halfLength
		    result = result + result
		    currentLength = currentLength + currentLength
		  Wend
		  
		  Var diff As Integer = targetLength - currentLength
		  result = result + result.LeftBytes(diff)
		  
		  Return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Repeat_DoublerMB(s As String, repetitions As Integer) As String
		  #If Not DebugBuild Then
		    #Pragma BackgroundTasks False
		    #Pragma BoundsChecking False
		    #Pragma NilObjectChecking False
		    #Pragma StackOverflowChecking False
		  #EndIf
		  
		  Var currentLength As Integer = s.Bytes
		  Var targetLength As Integer = currentLength * repetitions
		  Var halfLength As Integer = (targetLength + 1) \ 2
		  
		  Var mb As New MemoryBlock(targetLength)
		  
		  mb.StringValue(0, currentLength) = s
		  
		  While currentLength < halfLength
		    mb.CopyBytes(mb, 0, currentLength, currentLength)
		    currentLength = currentLength + currentLength
		  Wend
		  
		  Var diff As Integer = targetLength - currentLength
		  mb.CopyBytes(mb, 0, diff, currentLength)
		  
		  Return mb.StringValue(0, targetLength, s.Encoding)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StringTest()
		  Var addString As String = "123"
		  
		  Bench.Start "String Concat"
		  Var s As String
		  For i As Integer = 1 To Bench.N
		    s = s + addString
		  Next i
		  
		  Bench.Start "String Array"
		  Var stringArr() As String
		  For i As Integer = 1 to Bench.N
		    stringArr.Add addString
		  Next i
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
