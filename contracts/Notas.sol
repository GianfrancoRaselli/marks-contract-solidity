// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract Notas {

  // direccion del profesor dueño del contrato
  address public profesor = msg.sender;

  // mapping para relacionar el hash de la identidad del alumno con su nota del examen
  mapping(bytes32 => uint) notas;

  // array de los alumnos que pidan revisiones de examen
  string[] revisiones;


  // eventos
  event alumnoEvaluado(bytes32, uint);
  event revision(string);


  modifier unicamenteProfesor() {
    // requiere que la direccion del ejecutor de la funcion sea igual al dueño del contrato
    require(profesor == msg.sender, 'No tienes permisos para ejecutar esta funcion');
    _;
  }


  // funcion para evaluar a alumnos
  function evaluar(string memory _idAlumno, uint _nota) public unicamenteProfesor() {
    // hash de la identificacion del alumno
    bytes32 hashIdAlumno = keccak256(abi.encodePacked(_idAlumno));
    
    // relacion entre el hash de la identificacion del alumno y su nota
    notas[hashIdAlumno] = _nota;
    
    // emision del evento
    emit alumnoEvaluado(hashIdAlumno, _nota);
  }

  // funcion para ver las notas de un alumno
  function verNota(string memory _idAlumno) public view returns (uint) {
    // hash de la identificacion del alumno
    bytes32 hashIdAlumno = keccak256(abi.encodePacked(_idAlumno));
    
    // devolver la nota del alumno
    return notas[hashIdAlumno];
  }

  // funcion para solicitar una revision del examen
  function solicitarRevision(string memory _idAlumno) public {
    // almacenamiento de la identidad del alumno
    revisiones.push(_idAlumno);
    
    // emision del evento
    emit revision(_idAlumno);
  }

  // funcion para ver los alumnos que han solicitado revision del examen
  function verRevisiones() public view unicamenteProfesor() returns (string[] memory) {
    // devolver las identidades de los alumnos que han solicitado revision
    return revisiones;
  }

}
