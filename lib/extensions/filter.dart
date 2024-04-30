// this is a generic extension for performing a custiom filter
// on list of items contained in a stream

// this extension works a stream containing a list of 'T'
// * T is generic and can be anything (data wise)

extension Filter<T> on Stream<List<T>>{
  
  // This is the additional function being given via this extension
  // Its input is a boolean function that operates on T called "where"
  // Its return value is a Stream containing a List of T items

  Stream<List<T>> filter(bool Function(T) where) =>

    // map is used to take a stream and create an output stream based 
    // on specified transform instructions
    // Because the extension is defined to specifically operate
    // on streams, it is implicitly defined that the input is 
    // a stream, so no need to define it at all tbh

    // items is the contents of the stream, and as defined in the 
    // extension, it is a List of T type of items

    // where is a built in function/feature for iterables
    // it is effectively a filter, only returning items
    // that pass user defined conditions
    // so where does the actual action of filtering

    // So in plain english this code  says:
    // Take my Stream and using the map function, return a new stream 
    // with the following contents:
    // Take the old stream's items (for us its a singular List of T
    // but it technically could be multiple list) and perform where 
    // filtering on the list. so even planer, make a new strean with
    // a filtered list based off the old stream's list.

    // its imporrtant to understand that map is only taking the stream
    // contents , and creating a new list . We could have made any resulting
    // structure we wanted, we chose to make a list. In fact, at this point
    // it is just a copy of the input list.
    // The filtering is being done by the new lists ability to self filter itself
    // with the where clause.
    map ((items) => items.where(where).toList());
  
}