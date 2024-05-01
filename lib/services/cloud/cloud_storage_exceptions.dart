class CloudStorageExcception implements Exception{
  const CloudStorageExcception();
}

// C in CRUD
class CouldNotCreateNoteException extends CloudStorageExcception{}

//R in CRUD
class CouldNotGetAllNotesException extends CloudStorageExcception{}

//U in CRUD
class CouldNotUpdateNoteException extends CloudStorageExcception{}

//D in CRUD
class CouldNotDeleteNoteException extends CloudStorageExcception{}
 