Class {
	#name : #RJITBytecode,
	#superclass : #Object,
	#instVars : [
		'prototype',
		'position',
		'framedepth',
		'flashback',
		'opcode',
		'a',
		'b',
		'c',
		'd',
		'opcodeName'
	],
	#category : #'Studio-RaptorJIT'
}

{ #category : #accessing }
RJITBytecode >> framedepth [
	^ framedepth
]

{ #category : #initialization }
RJITBytecode >> from: bcreclog [
	| bcval prototypePointer |
	flashback := bcreclog flashback.
	prototypePointer := (bcreclog child: #pt).
	prototypePointer value = 0 ifTrue: [ 
		"Special case: unknown location."
		opcodeName := #<?>.
		^self ].
	prototype := RJITPrototype new from: (bcreclog child: #pt) dereference.
	position := (bcreclog child: #pos) value.
	framedepth := (bcreclog child: #framedepth) value.
	bcval := prototype bytecodeValue: position.
	opcode := bcval bitAnd: 16rFF.
	a := (bcval bitShift: -8) bitAnd: 16rFF.
	b := (bcval bitShift: -16) bitAnd: 16rFF.
	c := (bcval bitShift: -24) bitAnd: 16rFF.
	d := (bcval bitShift: -16) bitAnd: 16rFFFF.
	opcodeName := (flashback auditLog dwarf valueToName: opcode inEnumerationWith: 'BC_LOOP') asBytecodeInstructionType.

]

{ #category : #accessing }
RJITBytecode >> opcode [
	^ opcode
]

{ #category : #accessing }
RJITBytecode >> opcodeName [
	^ opcodeName
]

{ #category : #initialization }
RJITBytecode >> sourceLine [
	prototype ifNil: [ ^ '' ].
	^ [ prototype sourceName , ':' , (prototype bytecodeLine: position) asString ]
		ifCurtailed: [ ^'?' ].

]
