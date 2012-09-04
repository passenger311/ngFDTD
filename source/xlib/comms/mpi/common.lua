local _H = {
-------------------------------------------------------------------------------
FILE      = "xlib.comms.mpi.common",
VERSION   = "0.1",
DATE      = "18/08/2012 16:09",
COPYRIGHT = "(C) 2012 NEO·LIGHT Project",
-------------------------------------------------------------------------------
}


local ffi = require( "ffi" )
local xlib = require( "xlib" )
local module = xlib.module

-------------------------------------------------------------------------------

local G = _G

-------------------------------------------------------------------------------
--- <p><b>Module:</b> MPI function declarations. </p>
--
module( _H.FILE )
------------------------------------------------------------------------------


function inject(m)

   -- user functions

   ffi.cdef[[

typedef int (MPI_Copy_function)(MPI_Comm, int, void *,
                                void *, void *, int *);
typedef int (MPI_Delete_function)(MPI_Comm, int, void *, void *);
typedef int (MPI_Datarep_extent_function)(MPI_Datatype, MPI_Aint *, void *);
typedef int (MPI_Datarep_conversion_function)(void *, MPI_Datatype,
					      int, void *, MPI_Offset, void *);
typedef void (MPI_Comm_errhandler_function)(MPI_Comm *, int *, ...);

typedef void (ompi_file_errhandler_fn)(MPI_File *, int *, ...);
typedef ompi_file_errhandler_fn MPI_File_errhandler_function;
typedef void (MPI_Win_errhandler_function)(MPI_Win *, int *, ...);
typedef void (MPI_Handler_function)(MPI_Comm *, int *, ...);
typedef void (MPI_User_function)(void *, void *, int *, MPI_Datatype *);
typedef int (MPI_Comm_copy_attr_function)(MPI_Comm, int, void *,
					  void *, void *, int *);
typedef int (MPI_Comm_delete_attr_function)(MPI_Comm, int, void *, void *);
typedef int (MPI_Type_copy_attr_function)(MPI_Datatype, int, void *,
					  void *, void *, int *);
typedef int (MPI_Type_delete_attr_function)(MPI_Datatype, int,
					    void *, void *);
typedef int (MPI_Win_copy_attr_function)(MPI_Win, int, void *,
					 void *, void *, int *);
typedef int (MPI_Win_delete_attr_function)(MPI_Win, int, void *, void *);
typedef int (MPI_Grequest_query_function)(void *, MPI_Status *);
typedef int (MPI_Grequest_free_function)(void *);
typedef int (MPI_Grequest_cancel_function)(void *, int);

    ]]
    
    -- MPI-2 API functions

    ffi.cdef[[
	 
int MPI_Abort(MPI_Comm comm, int errorcode);
int MPI_Accumulate(void *origin_addr, int origin_count, MPI_Datatype origin_datatype,
		   int target_rank, MPI_Aint target_disp, int target_count,
		   MPI_Datatype target_datatype, MPI_Op op, MPI_Win win);
int MPI_Add_error_class(int *errorclass);
int MPI_Add_error_code(int errorclass, int *errorcode);
int MPI_Add_error_string(int errorcode, char *string);
int MPI_Allgather(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		  void *recvbuf, int recvcount,
		  MPI_Datatype recvtype, MPI_Comm comm);
int MPI_Allgatherv(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		   void *recvbuf, int *recvcounts,
		   int *displs, MPI_Datatype recvtype, MPI_Comm comm);
int MPI_Alloc_mem(MPI_Aint size, MPI_Info info,
		  void *baseptr);
int MPI_Allreduce(void *sendbuf, void *recvbuf, int count,
		  MPI_Datatype datatype, MPI_Op op, MPI_Comm comm);
int MPI_Alltoall(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		 void *recvbuf, int recvcount,
		 MPI_Datatype recvtype, MPI_Comm comm);
int MPI_Alltoallv(void *sendbuf, int *sendcounts, int *sdispls,
		  MPI_Datatype sendtype, void *recvbuf, int *recvcounts,
		  int *rdispls, MPI_Datatype recvtype, MPI_Comm comm);
int MPI_Alltoallw(void *sendbuf, int *sendcounts, int *sdispls, MPI_Datatype *sendtypes,
		  void *recvbuf, int *recvcounts, int *rdispls, MPI_Datatype *recvtypes,
		  MPI_Comm comm);
int MPI_Barrier(MPI_Comm comm);
int MPI_Bcast(void *buffer, int count, MPI_Datatype datatype,
	      int root, MPI_Comm comm);
int MPI_Bsend(void *buf, int count, MPI_Datatype datatype,
	       int dest, int tag, MPI_Comm comm);
int MPI_Bsend_init(void *buf, int count, MPI_Datatype datatype,
		   int dest, int tag, MPI_Comm comm, MPI_Request *request);
int MPI_Buffer_attach(void *buffer, int size);
int MPI_Buffer_detach(void *buffer, int *size);
int MPI_Cancel(MPI_Request *request);
int MPI_Cart_coords(MPI_Comm comm, int rank, int maxdims, int *coords);
int MPI_Cart_create(MPI_Comm old_comm, int ndims, int *dims,
		    int *periods, int reorder, MPI_Comm *comm_cart);
int MPI_Cart_get(MPI_Comm comm, int maxdims, int *dims,
		 int *periods, int *coords);
int MPI_Cart_map(MPI_Comm comm, int ndims, int *dims,
		  int *periods, int *newrank);
int MPI_Cart_rank(MPI_Comm comm, int *coords, int *rank);
int MPI_Cart_shift(MPI_Comm comm, int direction, int disp,
                   int *rank_source, int *rank_dest);
int MPI_Cart_sub(MPI_Comm comm, int *remain_dims, MPI_Comm *new_comm);
int MPI_Cartdim_get(MPI_Comm comm, int *ndims);
int MPI_Close_port(char *port_name);
int MPI_Comm_accept(char *port_name, MPI_Info info, int root,
		     MPI_Comm comm, MPI_Comm *newcomm);
MPI_Fint MPI_Comm_c2f(MPI_Comm comm);
int MPI_Comm_call_errhandler(MPI_Comm comm, int errorcode);
int MPI_Comm_compare(MPI_Comm comm1, MPI_Comm comm2, int *result);
int MPI_Comm_connect(char *port_name, MPI_Info info, int root,
		     MPI_Comm comm, MPI_Comm *newcomm);
int MPI_Comm_create_errhandler(MPI_Comm_errhandler_function *func,
			       MPI_Errhandler *errhandler);
int MPI_Comm_create_keyval(MPI_Comm_copy_attr_function *comm_copy_attr_fn,
			   MPI_Comm_delete_attr_function *comm_delete_attr_fn,
			   int *comm_keyval, void *extra_state);
int MPI_Comm_create(MPI_Comm comm, MPI_Group group, MPI_Comm *newcomm);
int MPI_Comm_delete_attr(MPI_Comm comm, int comm_keyval);
int MPI_Comm_disconnect(MPI_Comm *comm);
int MPI_Comm_dup(MPI_Comm comm, MPI_Comm *newcomm);
MPI_Comm MPI_Comm_f2c(MPI_Fint comm);
int MPI_Comm_free_keyval(int *comm_keyval);
int MPI_Comm_free(MPI_Comm *comm);
int MPI_Comm_get_attr(MPI_Comm comm, int comm_keyval,
		      void *attribute_val, int *flag);
int MPI_Comm_get_errhandler(MPI_Comm comm, MPI_Errhandler *erhandler);
int MPI_Comm_get_name(MPI_Comm comm, char *comm_name, int *resultlen);
int MPI_Comm_get_parent(MPI_Comm *parent);
int MPI_Comm_group(MPI_Comm comm, MPI_Group *group);
int MPI_Comm_join(int fd, MPI_Comm *intercomm);
int MPI_Comm_rank(MPI_Comm comm, int *rank);
int MPI_Comm_remote_group(MPI_Comm comm, MPI_Group *group);
int MPI_Comm_remote_size(MPI_Comm comm, int *size);
int MPI_Comm_set_attr(MPI_Comm comm, int comm_keyval, void *attribute_val);
int MPI_Comm_set_errhandler(MPI_Comm comm, MPI_Errhandler errhandler);
int MPI_Comm_set_name(MPI_Comm comm, char *comm_name);
int MPI_Comm_size(MPI_Comm comm, int *size);
int MPI_Comm_spawn(char *command, char **argv, int maxprocs, MPI_Info info,
		   int root, MPI_Comm comm, MPI_Comm *intercomm,
		   int *array_of_errcodes);
int MPI_Comm_spawn_multiple(int count, char **array_of_commands, char ***array_of_argv,
			    int *array_of_maxprocs, MPI_Info *array_of_info,
			    int root, MPI_Comm comm, MPI_Comm *intercomm,
			    int *array_of_errcodes);
int MPI_Comm_split(MPI_Comm comm, int color, int key, MPI_Comm *newcomm);
int MPI_Comm_test_inter(MPI_Comm comm, int *flag);
int MPI_Dims_create(int nnodes, int ndims, int *dims);
MPI_Fint MPI_Errhandler_c2f(MPI_Errhandler errhandler);
MPI_Errhandler MPI_Errhandler_f2c(MPI_Fint errhandler);
int MPI_Errhandler_free(MPI_Errhandler *errhandler);
int MPI_Error_class(int errorcode, int *errorclass);
int MPI_Error_string(int errorcode, char *string, int *resultlen);
int MPI_Exscan(void *sendbuf, void *recvbuf, int count,
		MPI_Datatype datatype, MPI_Op op, MPI_Comm comm);
MPI_Fint MPI_File_c2f(MPI_File file);
MPI_File MPI_File_f2c(MPI_Fint file);
int MPI_File_call_errhandler(MPI_File fh, int errorcode);
int MPI_File_create_errhandler(MPI_File_errhandler_function *func,
			       MPI_Errhandler *errhandler);
int MPI_File_set_errhandler( MPI_File file, MPI_Errhandler errhandler);
int MPI_File_get_errhandler( MPI_File file, MPI_Errhandler *errhandler);
int MPI_File_open(MPI_Comm comm, char *filename, int amode,
		  MPI_Info info, MPI_File *fh);
int MPI_File_close(MPI_File *fh);
int MPI_File_delete(char *filename, MPI_Info info);
int MPI_File_set_size(MPI_File fh, MPI_Offset size);
int MPI_File_preallocate(MPI_File fh, MPI_Offset size);
int MPI_File_get_size(MPI_File fh, MPI_Offset *size);
int MPI_File_get_group(MPI_File fh, MPI_Group *group);
int MPI_File_get_amode(MPI_File fh, int *amode);
int MPI_File_set_info(MPI_File fh, MPI_Info info);
int MPI_File_get_info(MPI_File fh, MPI_Info *info_used);
int MPI_File_set_view(MPI_File fh, MPI_Offset disp, MPI_Datatype etype,
		      MPI_Datatype filetype, char *datarep, MPI_Info info);
int MPI_File_get_view(MPI_File fh, MPI_Offset *disp,
		      MPI_Datatype *etype,
		      MPI_Datatype *filetype, char *datarep);
int MPI_File_read_at(MPI_File fh, MPI_Offset offset, void *buf,
		     int count, MPI_Datatype datatype, MPI_Status *status);
int MPI_File_read_at_all(MPI_File fh, MPI_Offset offset, void *buf,
			 int count, MPI_Datatype datatype, MPI_Status *status);
int MPI_File_write_at(MPI_File fh, MPI_Offset offset, void *buf,
		      int count, MPI_Datatype datatype, MPI_Status *status);
int MPI_File_write_at_all(MPI_File fh, MPI_Offset offset, void *buf,
			  int count, MPI_Datatype datatype, MPI_Status *status);
int MPI_File_iread_at(MPI_File fh, MPI_Offset offset, void *buf,
		      int count, MPI_Datatype datatype, MPI_Request *request);
int MPI_File_iwrite_at(MPI_File fh, MPI_Offset offset, void *buf,
		       int count, MPI_Datatype datatype, MPI_Request *request);
int MPI_File_read(MPI_File fh, void *buf, int count,			   
		  MPI_Datatype datatype, MPI_Status *status);
int MPI_File_read_all(MPI_File fh, void *buf, int count,
		      MPI_Datatype datatype, MPI_Status *status);
int MPI_File_write(MPI_File fh, void *buf, int count,
		   MPI_Datatype datatype, MPI_Status *status);
int MPI_File_write_all(MPI_File fh, void *buf, int count,
		       MPI_Datatype datatype, MPI_Status *status);
int MPI_File_iread(MPI_File fh, void *buf, int count,
		   MPI_Datatype datatype, MPI_Request *request);
int MPI_File_iwrite(MPI_File fh, void *buf, int count,
		    MPI_Datatype datatype, MPI_Request *request);
int MPI_File_seek(MPI_File fh, MPI_Offset offset, int whence);
int MPI_File_get_position(MPI_File fh, MPI_Offset *offset);
int MPI_File_get_byte_offset(MPI_File fh, MPI_Offset offset,
			     MPI_Offset *disp);
int MPI_File_read_shared(MPI_File fh, void *buf, int count,
			 MPI_Datatype datatype, MPI_Status *status);
int MPI_File_write_shared(MPI_File fh, void *buf, int count,
			  MPI_Datatype datatype, MPI_Status *status);
int MPI_File_iread_shared(MPI_File fh, void *buf, int count,
			  MPI_Datatype datatype, MPI_Request *request);
int MPI_File_iwrite_shared(MPI_File fh, void *buf, int count,
			   MPI_Datatype datatype, MPI_Request *request);
int MPI_File_read_ordered(MPI_File fh, void *buf, int count,
			  MPI_Datatype datatype, MPI_Status *status);
int MPI_File_write_ordered(MPI_File fh, void *buf, int count,
			    MPI_Datatype datatype, MPI_Status *status);
int MPI_File_seek_shared(MPI_File fh, MPI_Offset offset, int whence);
int MPI_File_get_position_shared(MPI_File fh, MPI_Offset *offset);
int MPI_File_read_at_all_begin(MPI_File fh, MPI_Offset offset, void *buf,
			       int count, MPI_Datatype datatype);
int MPI_File_read_at_all_end(MPI_File fh, void *buf, MPI_Status *status);
int MPI_File_write_at_all_begin(MPI_File fh, MPI_Offset offset, void *buf,
				int count, MPI_Datatype datatype);
int MPI_File_write_at_all_end(MPI_File fh, void *buf, MPI_Status *status);
int MPI_File_read_all_begin(MPI_File fh, void *buf, int count,
			    MPI_Datatype datatype);
int MPI_File_read_all_end(MPI_File fh, void *buf, MPI_Status *status);
int MPI_File_write_all_begin(MPI_File fh, void *buf, int count,
			     MPI_Datatype datatype);
int MPI_File_write_all_end(MPI_File fh, void *buf, MPI_Status *status);
int MPI_File_read_ordered_begin(MPI_File fh, void *buf, int count,
				MPI_Datatype datatype);
int MPI_File_read_ordered_end(MPI_File fh, void *buf, MPI_Status *status);
int MPI_File_write_ordered_begin(MPI_File fh, void *buf, int count,
				 MPI_Datatype datatype);
int MPI_File_write_ordered_end(MPI_File fh, void *buf, MPI_Status *status);
int MPI_File_get_type_extent(MPI_File fh, MPI_Datatype datatype,
			     MPI_Aint *extent);
int MPI_File_set_atomicity(MPI_File fh, int flag);
int MPI_File_get_atomicity(MPI_File fh, int *flag);
int MPI_File_sync(MPI_File fh);
int MPI_Finalize(void);
int MPI_Finalized(int *flag);
int MPI_Free_mem(void *base);
int MPI_Gather(void *sendbuf, int sendcount, MPI_Datatype sendtype,
	       void *recvbuf, int recvcount, MPI_Datatype recvtype,
	       int root, MPI_Comm comm);
int MPI_Gatherv(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		void *recvbuf, int *recvcounts, int *displs,
		MPI_Datatype recvtype, int root, MPI_Comm comm);
int MPI_Get_address(void *location, MPI_Aint *address);
int MPI_Get_count(MPI_Status *status, MPI_Datatype datatype, int *count);
int MPI_Get_elements(MPI_Status *status, MPI_Datatype datatype, int *count);
int MPI_Get(void *origin_addr, int origin_count,
	    MPI_Datatype origin_datatype, int target_rank,
	    MPI_Aint target_disp, int target_count,
	    MPI_Datatype target_datatype, MPI_Win win);
int MPI_Get_processor_name(char *name, int *resultlen);
int MPI_Get_version(int *version, int *subversion);
int MPI_Graph_create(MPI_Comm comm_old, int nnodes, int *index,
		     int *edges, int reorder, MPI_Comm *comm_graph);
int MPI_Graph_get(MPI_Comm comm, int maxindex, int maxedges,
		  int *index, int *edges);
int MPI_Graph_map(MPI_Comm comm, int nnodes, int *index, int *edges,
		  int *newrank);
int MPI_Graph_neighbors_count(MPI_Comm comm, int rank, int *nneighbors);
int MPI_Graph_neighbors(MPI_Comm comm, int rank, int maxneighbors,
			int *neighbors);
int MPI_Graphdims_get(MPI_Comm comm, int *nnodes, int *nedges);
int MPI_Grequest_complete(MPI_Request request);
int MPI_Grequest_start(MPI_Grequest_query_function *query_fn,
		       MPI_Grequest_free_function *free_fn,
		       MPI_Grequest_cancel_function *cancel_fn,
		       void *extra_state, MPI_Request *request);
MPI_Fint MPI_Group_c2f(MPI_Group group);
int MPI_Group_compare(MPI_Group group1, MPI_Group group2, int *result);
int MPI_Group_difference(MPI_Group group1, MPI_Group group2,
			 MPI_Group *newgroup);
int MPI_Group_excl(MPI_Group group, int n, int *ranks,
		   MPI_Group *newgroup);
MPI_Group MPI_Group_f2c(MPI_Fint group);
int MPI_Group_free(MPI_Group *group);
int MPI_Group_incl(MPI_Group group, int n, int *ranks,
		   MPI_Group *newgroup);
int MPI_Group_intersection(MPI_Group group1, MPI_Group group2,
			   MPI_Group *newgroup);
int MPI_Group_range_excl(MPI_Group group, int n, int ranges[][3],
			 MPI_Group *newgroup);
int MPI_Group_range_incl(MPI_Group group, int n, int ranges[][3],
			  MPI_Group *newgroup);
int MPI_Group_rank(MPI_Group group, int *rank);
int MPI_Group_size(MPI_Group group, int *size);
int MPI_Group_translate_ranks(MPI_Group group1, int n, int *ranks1,
			      MPI_Group group2, int *ranks2);
int MPI_Group_union(MPI_Group group1, MPI_Group group2,
		     MPI_Group *newgroup);
int MPI_Ibsend(void *buf, int count, MPI_Datatype datatype, int dest,
	       int tag, MPI_Comm comm, MPI_Request *request);
MPI_Fint MPI_Info_c2f(MPI_Info info);
int MPI_Info_create(MPI_Info *info);
int MPI_Info_delete(MPI_Info info, char *key);
int MPI_Info_dup(MPI_Info info, MPI_Info *newinfo);
MPI_Info MPI_Info_f2c(MPI_Fint info);
int MPI_Info_free(MPI_Info *info);
int MPI_Info_get(MPI_Info info, char *key, int valuelen,
		 char *value, int *flag);
int MPI_Info_get_nkeys(MPI_Info info, int *nkeys);
int MPI_Info_get_nthkey(MPI_Info info, int n, char *key);
int MPI_Info_get_valuelen(MPI_Info info, char *key, int *valuelen,
			  int *flag);
int MPI_Info_set(MPI_Info info, char *key, char *value);
int MPI_Init(int *argc, char ***argv);
int MPI_Initialized(int *flag);
int MPI_Init_thread(int *argc, char ***argv, int required,
		    int *provided);
int MPI_Intercomm_create(MPI_Comm local_comm, int local_leader,
			 MPI_Comm bridge_comm, int remote_leader,
			 int tag, MPI_Comm *newintercomm);
int MPI_Intercomm_merge(MPI_Comm intercomm, int high,
			MPI_Comm *newintercomm);
int MPI_Iprobe(int source, int tag, MPI_Comm comm, int *flag,
	       MPI_Status *status);
int MPI_Irecv(void *buf, int count, MPI_Datatype datatype, int source,
	      int tag, MPI_Comm comm, MPI_Request *request);
int MPI_Irsend(void *buf, int count, MPI_Datatype datatype, int dest,
	       int tag, MPI_Comm comm, MPI_Request *request);
int MPI_Isend(void *buf, int count, MPI_Datatype datatype, int dest,
	      int tag, MPI_Comm comm, MPI_Request *request);
int MPI_Issend(void *buf, int count, MPI_Datatype datatype, int dest,
	       int tag, MPI_Comm comm, MPI_Request *request);
int MPI_Is_thread_main(int *flag);
int MPI_Lookup_name(char *service_name, MPI_Info info, char *port_name);
MPI_Fint MPI_Op_c2f(MPI_Op op);
int MPI_Op_commutative(MPI_Op op, int *commute);
int MPI_Op_create(MPI_User_function *func, int commute, MPI_Op *op);
int MPI_Open_port(MPI_Info info, char *port_name);
MPI_Op MPI_Op_f2c(MPI_Fint op);
int MPI_Op_free(MPI_Op *op);
int MPI_Pack_external(char *datarep, void *inbuf, int incount,
		      MPI_Datatype datatype, void *outbuf,
		      MPI_Aint outsize, MPI_Aint *position);
int MPI_Pack_external_size(char *datarep, int incount,
			   MPI_Datatype datatype, MPI_Aint *size);
int MPI_Pack(void *inbuf, int incount, MPI_Datatype datatype,
	     void *outbuf, int outsize, int *position, MPI_Comm comm);
int MPI_Pack_size(int incount, MPI_Datatype datatype, MPI_Comm comm,
		  int *size);
int MPI_Pcontrol(const int level, ...);
int MPI_Probe(int source, int tag, MPI_Comm comm, MPI_Status *status);
int MPI_Publish_name(char *service_name, MPI_Info info,
		     char *port_name);
int MPI_Put(void *origin_addr, int origin_count, MPI_Datatype origin_datatype,
	    int target_rank, MPI_Aint target_disp, int target_count,
	    MPI_Datatype target_datatype, MPI_Win win);
int MPI_Query_thread(int *provided);
int MPI_Recv_init(void *buf, int count, MPI_Datatype datatype, int source,
		  int tag, MPI_Comm comm, MPI_Request *request);
int MPI_Recv(void *buf, int count, MPI_Datatype datatype, int source,
		      int tag, MPI_Comm comm, MPI_Status *status);
int MPI_Reduce(void *sendbuf, void *recvbuf, int count,
	       MPI_Datatype datatype, MPI_Op op, int root, MPI_Comm comm);
int MPI_Reduce_local(void *inbuf, void *inoutbuf, int count,
		     MPI_Datatype datatype, MPI_Op op);
int MPI_Reduce_scatter(void *sendbuf, void *recvbuf, int *recvcounts,
		       MPI_Datatype datatype, MPI_Op op, MPI_Comm comm);
int MPI_Register_datarep(char *datarep,
			 MPI_Datarep_conversion_function *read_conversion_fn,
			 MPI_Datarep_conversion_function *write_conversion_fn,
			 MPI_Datarep_extent_function *dtype_file_extent_fn,
			 void *extra_state);
MPI_Fint MPI_Request_c2f(MPI_Request request);
MPI_Request MPI_Request_f2c(MPI_Fint request);
int MPI_Request_free(MPI_Request *request);
int MPI_Request_get_status(MPI_Request request, int *flag,
			   MPI_Status *status);
int MPI_Rsend(void *ibuf, int count, MPI_Datatype datatype, int dest,
	      int tag, MPI_Comm comm);
int MPI_Rsend_init(void *buf, int count, MPI_Datatype datatype,
		   int dest, int tag, MPI_Comm comm,
		   MPI_Request *request);
int MPI_Scan(void *sendbuf, void *recvbuf, int count,
	     MPI_Datatype datatype, MPI_Op op, MPI_Comm comm);
int MPI_Scatter(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		void *recvbuf, int recvcount, MPI_Datatype recvtype,
		int root, MPI_Comm comm);
int MPI_Scatterv(void *sendbuf, int *sendcounts, int *displs,
		 MPI_Datatype sendtype, void *recvbuf, int recvcount,
		 MPI_Datatype recvtype, int root, MPI_Comm comm);
int MPI_Send_init(void *buf, int count, MPI_Datatype datatype,
		  int dest, int tag, MPI_Comm comm,
		  MPI_Request *request);
int MPI_Send(void *buf, int count, MPI_Datatype datatype, int dest,
	     int tag, MPI_Comm comm);
int MPI_Sendrecv(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		 int dest, int sendtag, void *recvbuf, int recvcount,
		 MPI_Datatype recvtype, int source, int recvtag,
		 MPI_Comm comm,  MPI_Status *status);
int MPI_Sendrecv_replace(void * buf, int count, MPI_Datatype datatype,
			 int dest, int sendtag, int source, int recvtag,
			 MPI_Comm comm, MPI_Status *status);
int MPI_Ssend_init(void *buf, int count, MPI_Datatype datatype,
		   int dest, int tag, MPI_Comm comm,
		   MPI_Request *request);
int MPI_Ssend(void *buf, int count, MPI_Datatype datatype, int dest,
	      int tag, MPI_Comm comm);
int MPI_Start(MPI_Request *request);
int MPI_Startall(int count, MPI_Request *array_of_requests);
int MPI_Status_c2f(MPI_Status *c_status, MPI_Fint *f_status);
int MPI_Status_f2c(MPI_Fint *f_status, MPI_Status *c_status);
int MPI_Status_set_cancelled(MPI_Status *status, int flag);
int MPI_Status_set_elements(MPI_Status *status, MPI_Datatype datatype,
			    int count);
int MPI_Testall(int count, MPI_Request array_of_requests[], int *flag,
		MPI_Status array_of_statuses[]);
int MPI_Testany(int count, MPI_Request array_of_requests[], int *index,
		int *flag, MPI_Status *status);
int MPI_Test(MPI_Request *request, int *flag, MPI_Status *status);
int MPI_Test_cancelled(MPI_Status *status, int *flag);
int MPI_Testsome(int incount, MPI_Request array_of_requests[],
		 int *outcount, int array_of_indices[],
		 MPI_Status array_of_statuses[]);
int MPI_Topo_test(MPI_Comm comm, int *status);
MPI_Fint MPI_Type_c2f(MPI_Datatype datatype);
int MPI_Type_commit(MPI_Datatype *type);
int MPI_Type_contiguous(int count, MPI_Datatype oldtype,
			MPI_Datatype *newtype);
int MPI_Type_create_darray(int size, int rank, int ndims,
			   int gsize_array[], int distrib_array[],
			   int darg_array[], int psize_array[],
			   int order, MPI_Datatype oldtype,
			   MPI_Datatype *newtype);
int MPI_Type_create_f90_complex(int p, int r, MPI_Datatype *newtype);
int MPI_Type_create_f90_integer(int r, MPI_Datatype *newtype);
int MPI_Type_create_f90_real(int p, int r, MPI_Datatype *newtype);
int MPI_Type_create_hindexed(int count, int array_of_blocklengths[],
			     MPI_Aint array_of_displacements[],
			     MPI_Datatype oldtype,
			     MPI_Datatype *newtype);
int MPI_Type_create_hvector(int count, int blocklength, MPI_Aint stride,
			    MPI_Datatype oldtype,
			    MPI_Datatype *newtype);
int MPI_Type_create_keyval(MPI_Type_copy_attr_function *type_copy_attr_fn,
			   MPI_Type_delete_attr_function *type_delete_attr_fn,
			   int *type_keyval, void *extra_state);
int MPI_Type_create_indexed_block(int count, int blocklength,
				  int array_of_displacements[],
				  MPI_Datatype oldtype,
				  MPI_Datatype *newtype);
int MPI_Type_create_struct(int count, int array_of_block_lengths[],
			   MPI_Aint array_of_displacements[],
			   MPI_Datatype array_of_types[],
				    MPI_Datatype *newtype);
int MPI_Type_create_subarray(int ndims, int size_array[], int subsize_array[],
			     int start_array[], int order,
			     MPI_Datatype oldtype, MPI_Datatype *newtype);
int MPI_Type_create_resized(MPI_Datatype oldtype, MPI_Aint lb,
			    MPI_Aint extent, MPI_Datatype *newtype);
int MPI_Type_delete_attr(MPI_Datatype type, int type_keyval);
int MPI_Type_dup(MPI_Datatype type, MPI_Datatype *newtype);
int MPI_Type_free(MPI_Datatype *type);
int MPI_Type_free_keyval(int *type_keyval);
MPI_Datatype MPI_Type_f2c(MPI_Fint datatype);
int MPI_Type_get_attr(MPI_Datatype type, int type_keyval,
		      void *attribute_val, int *flag);
int MPI_Type_get_contents(MPI_Datatype mtype, int max_integers,
			  int max_addresses, int max_datatypes,
			  int array_of_integers[],
			  MPI_Aint array_of_addresses[],
			  MPI_Datatype array_of_datatypes[]);
int MPI_Type_get_envelope(MPI_Datatype type, int *num_integers,
			  int *num_addresses, int *num_datatypes,
			  int *combiner);
int MPI_Type_get_extent(MPI_Datatype type, MPI_Aint *lb,
			MPI_Aint *extent);
int MPI_Type_get_name(MPI_Datatype type, char *type_name,
		      int *resultlen);
int MPI_Type_get_true_extent(MPI_Datatype datatype, MPI_Aint *true_lb,
			     MPI_Aint *true_extent);
int MPI_Type_indexed(int count, int array_of_blocklengths[],
		     int array_of_displacements[],
		     MPI_Datatype oldtype, MPI_Datatype *newtype);
int MPI_Type_match_size(int typeclass, int size, MPI_Datatype *type);
int MPI_Type_set_attr(MPI_Datatype type, int type_keyval,
		      void *attr_val);
int MPI_Type_set_name(MPI_Datatype type, char *type_name);
int MPI_Type_size(MPI_Datatype type, int *size);
int MPI_Type_vector(int count, int blocklength, int stride,
		    MPI_Datatype oldtype, MPI_Datatype *newtype);
int MPI_Unpack(void *inbuf, int insize, int *position,
	       void *outbuf, int outcount, MPI_Datatype datatype,
	       MPI_Comm comm);
int MPI_Unpublish_name(char *service_name, MPI_Info info, char *port_name);
int MPI_Unpack_external (char *datarep, void *inbuf, MPI_Aint insize,
			 MPI_Aint *position, void *outbuf, int outcount,
			 MPI_Datatype datatype);
int MPI_Waitall(int count, MPI_Request *array_of_requests,
		MPI_Status *array_of_statuses);
int MPI_Waitany(int count, MPI_Request *array_of_requests,
		int *index, MPI_Status *status);
int MPI_Wait(MPI_Request *request, MPI_Status *status);
int MPI_Waitsome(int incount, MPI_Request *array_of_requests,
		 int *outcount, int *array_of_indices,
		 MPI_Status *array_of_statuses);
MPI_Fint MPI_Win_c2f(MPI_Win win);
int MPI_Win_call_errhandler(MPI_Win win, int errorcode);
int MPI_Win_complete(MPI_Win win);
int MPI_Win_create(void *base, MPI_Aint size, int disp_unit,
		   MPI_Info info, MPI_Comm comm, MPI_Win *win);
int MPI_Win_create_errhandler(MPI_Win_errhandler_function *func,
			      MPI_Errhandler *errhandler);
int MPI_Win_create_keyval(MPI_Win_copy_attr_function *win_copy_attr_fn,
			  MPI_Win_delete_attr_function *win_delete_attr_fn,
			  int *win_keyval, void *extra_state);
int MPI_Win_delete_attr(MPI_Win win, int win_keyval);
MPI_Win MPI_Win_f2c(MPI_Fint win);
int MPI_Win_fence(int assert, MPI_Win win);
int MPI_Win_free(MPI_Win *win);
int MPI_Win_free_keyval(int *win_keyval);
int MPI_Win_get_attr(MPI_Win win, int win_keyval,
		     void *attribute_val, int *flag);
int MPI_Win_get_errhandler(MPI_Win win, MPI_Errhandler *errhandler);
int MPI_Win_get_group(MPI_Win win, MPI_Group *group);
int MPI_Win_get_name(MPI_Win win, char *win_name, int *resultlen);
int MPI_Win_lock(int lock_type, int rank, int assert, MPI_Win win);
int MPI_Win_post(MPI_Group group, int assert, MPI_Win win);
int MPI_Win_set_attr(MPI_Win win, int win_keyval, void *attribute_val);
int MPI_Win_set_errhandler(MPI_Win win, MPI_Errhandler errhandler);
int MPI_Win_set_name(MPI_Win win, char *win_name);
int MPI_Win_start(MPI_Group group, int assert, MPI_Win win);
int MPI_Win_test(MPI_Win win, int *flag);
int MPI_Win_unlock(int rank, MPI_Win win);
int MPI_Win_wait(MPI_Win win);
double MPI_Wtick(void);
double MPI_Wtime(void);
	
  ]]


  -- MPI-2 Profiling Functions

  if m.profile then

     ffi.cdef[[
 
int PMPI_Abort(MPI_Comm comm, int errorcode);
int PMPI_Accumulate(void *origin_addr, int origin_count, MPI_Datatype origin_datatype,
		    int target_rank, MPI_Aint target_disp, int target_count,
		    MPI_Datatype target_datatype, MPI_Op op, MPI_Win win);
int PMPI_Add_error_class(int *errorclass);
int PMPI_Add_error_code(int errorclass, int *errorcode);
int PMPI_Add_error_string(int errorcode, char *string);
int PMPI_Allgather(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		   void *recvbuf, int recvcount,
		   MPI_Datatype recvtype, MPI_Comm comm);
int PMPI_Allgatherv(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		    void *recvbuf, int *recvcounts,
		    int *displs, MPI_Datatype recvtype, MPI_Comm comm);
int PMPI_Alloc_mem(MPI_Aint size, MPI_Info info,
		   void *baseptr);
int PMPI_Allreduce(void *sendbuf, void *recvbuf, int count,
		   MPI_Datatype datatype, MPI_Op op, MPI_Comm comm);
int PMPI_Alltoall(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		  void *recvbuf, int recvcount,
		  MPI_Datatype recvtype, MPI_Comm comm);
int PMPI_Alltoallv(void *sendbuf, int *sendcounts, int *sdispls,
		   MPI_Datatype sendtype, void *recvbuf, int *recvcounts,
		   int *rdispls, MPI_Datatype recvtype, MPI_Comm comm);
int PMPI_Alltoallw(void *sendbuf, int *sendcounts, int *sdispls, MPI_Datatype *sendtypes,
		   void *recvbuf, int *recvcounts, int *rdispls, MPI_Datatype *recvtypes,
		   MPI_Comm comm);
int PMPI_Barrier(MPI_Comm comm);
int PMPI_Bcast(void *buffer, int count, MPI_Datatype datatype,
		int root, MPI_Comm comm);
int PMPI_Bsend(void *buf, int count, MPI_Datatype datatype,
	       int dest, int tag, MPI_Comm comm);
int PMPI_Bsend_init(void *buf, int count, MPI_Datatype datatype,
		     int dest, int tag, MPI_Comm comm, MPI_Request *request);
int PMPI_Buffer_attach(void *buffer, int size);
int PMPI_Buffer_detach(void *buffer, int *size);
int PMPI_Cancel(MPI_Request *request);
int PMPI_Cart_coords(MPI_Comm comm, int rank, int maxdims, int *coords);
int PMPI_Cart_create(MPI_Comm old_comm, int ndims, int *dims,
		     int *periods, int reorder, MPI_Comm *comm_cart);
int PMPI_Cart_get(MPI_Comm comm, int maxdims, int *dims,
		   int *periods, int *coords);
int PMPI_Cart_map(MPI_Comm comm, int ndims, int *dims,
		  int *periods, int *newrank);
int PMPI_Cart_rank(MPI_Comm comm, int *coords, int *rank);
int PMPI_Cart_shift(MPI_Comm comm, int direction, int disp,
		    int *rank_source, int *rank_dest);
int PMPI_Cart_sub(MPI_Comm comm, int *remain_dims, MPI_Comm *new_comm);
int PMPI_Cartdim_get(MPI_Comm comm, int *ndims);
int PMPI_Close_port(char *port_name);
int PMPI_Comm_accept(char *port_name, MPI_Info info, int root,
		     MPI_Comm comm, MPI_Comm *newcomm);
MPI_Fint PMPI_Comm_c2f(MPI_Comm comm);
int PMPI_Comm_call_errhandler(MPI_Comm comm, int errorcode);
int PMPI_Comm_compare(MPI_Comm comm1, MPI_Comm comm2, int *result);
int PMPI_Comm_connect(char *port_name, MPI_Info info, int root,
		      MPI_Comm comm, MPI_Comm *newcomm);
int PMPI_Comm_create_errhandler(MPI_Comm_errhandler_function *func,
				MPI_Errhandler *errhandler);
int PMPI_Comm_create_keyval(MPI_Comm_copy_attr_function *comm_copy_attr_fn,
			    MPI_Comm_delete_attr_function *comm_delete_attr_fn,
			    int *comm_keyval, void *extra_state);
int PMPI_Comm_create(MPI_Comm comm, MPI_Group group, MPI_Comm *newcomm);
int PMPI_Comm_delete_attr(MPI_Comm comm, int comm_keyval);
int PMPI_Comm_disconnect(MPI_Comm *comm);
int PMPI_Comm_dup(MPI_Comm comm, MPI_Comm *newcomm);
MPI_Comm PMPI_Comm_f2c(MPI_Fint comm);
int PMPI_Comm_free_keyval(int *comm_keyval);
int PMPI_Comm_free(MPI_Comm *comm);
int PMPI_Comm_get_attr(MPI_Comm comm, int comm_keyval,
		       void *attribute_val, int *flag);
int PMPI_Comm_get_errhandler(MPI_Comm comm, MPI_Errhandler *erhandler);
int PMPI_Comm_get_name(MPI_Comm comm, char *comm_name, int *resultlen);
int PMPI_Comm_get_parent(MPI_Comm *parent);
int PMPI_Comm_group(MPI_Comm comm, MPI_Group *group);
int PMPI_Comm_join(int fd, MPI_Comm *intercomm);
int PMPI_Comm_rank(MPI_Comm comm, int *rank);
int PMPI_Comm_remote_group(MPI_Comm comm, MPI_Group *group);
int PMPI_Comm_remote_size(MPI_Comm comm, int *size);
int PMPI_Comm_set_attr(MPI_Comm comm, int comm_keyval, void *attribute_val);
int PMPI_Comm_set_errhandler(MPI_Comm comm, MPI_Errhandler errhandler);
int PMPI_Comm_set_name(MPI_Comm comm, char *comm_name);
int PMPI_Comm_size(MPI_Comm comm, int *size);
int PMPI_Comm_spawn(char *command, char **argv, int maxprocs, MPI_Info info,
		    int root, MPI_Comm comm, MPI_Comm *intercomm,
		    int *array_of_errcodes);
int PMPI_Comm_spawn_multiple(int count, char **array_of_commands, char ***array_of_argv,
			     int *array_of_maxprocs, MPI_Info *array_of_info,
			     int root, MPI_Comm comm, MPI_Comm *intercomm,
			     int *array_of_errcodes);
int PMPI_Comm_split(MPI_Comm comm, int color, int key, MPI_Comm *newcomm);
int PMPI_Comm_test_inter(MPI_Comm comm, int *flag);
int PMPI_Dims_create(int nnodes, int ndims, int *dims);
MPI_Fint PMPI_Errhandler_c2f(MPI_Errhandler errhandler);
MPI_Errhandler PMPI_Errhandler_f2c(MPI_Fint errhandler);
int PMPI_Errhandler_free(MPI_Errhandler *errhandler);
int PMPI_Error_class(int errorcode, int *errorclass);
int PMPI_Error_string(int errorcode, char *string, int *resultlen);
int PMPI_Exscan(void *sendbuf, void *recvbuf, int count,
		MPI_Datatype datatype, MPI_Op op, MPI_Comm comm);
MPI_Fint PMPI_File_c2f(MPI_File file);
MPI_File PMPI_File_f2c(MPI_Fint file);
int PMPI_File_call_errhandler(MPI_File fh, int errorcode);
int PMPI_File_create_errhandler(MPI_File_errhandler_function *func,
				MPI_Errhandler *errhandler);
int PMPI_File_set_errhandler( MPI_File file, MPI_Errhandler errhandler);
int PMPI_File_get_errhandler( MPI_File file, MPI_Errhandler *errhandler);
int PMPI_File_open(MPI_Comm comm, char *filename, int amode,
		   MPI_Info info, MPI_File *fh);
int PMPI_File_close(MPI_File *fh);
int PMPI_File_delete(char *filename, MPI_Info info);
int PMPI_File_set_size(MPI_File fh, MPI_Offset size);
int PMPI_File_preallocate(MPI_File fh, MPI_Offset size);
int PMPI_File_get_size(MPI_File fh, MPI_Offset *size);
int PMPI_File_get_group(MPI_File fh, MPI_Group *group);
int PMPI_File_get_amode(MPI_File fh, int *amode);
int PMPI_File_set_info(MPI_File fh, MPI_Info info);
int PMPI_File_get_info(MPI_File fh, MPI_Info *info_used);
int PMPI_File_set_view(MPI_File fh, MPI_Offset disp, MPI_Datatype etype,
		       MPI_Datatype filetype, char *datarep, MPI_Info info);
int PMPI_File_get_view(MPI_File fh, MPI_Offset *disp,
		       MPI_Datatype *etype,
		       MPI_Datatype *filetype, char *datarep);
int PMPI_File_read_at(MPI_File fh, MPI_Offset offset, void *buf,
		      int count, MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_read_at_all(MPI_File fh, MPI_Offset offset, void *buf,
			  int count, MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_write_at(MPI_File fh, MPI_Offset offset, void *buf,
		       int count, MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_write_at_all(MPI_File fh, MPI_Offset offset, void *buf,
			   int count, MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_iread_at(MPI_File fh, MPI_Offset offset, void *buf,
		       int count, MPI_Datatype datatype, MPI_Request *request);
int PMPI_File_iwrite_at(MPI_File fh, MPI_Offset offset, void *buf,
			int count, MPI_Datatype datatype, MPI_Request *request);
int PMPI_File_read(MPI_File fh, void *buf, int count,
		   MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_read_all(MPI_File fh, void *buf, int count,
		       MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_write(MPI_File fh, void *buf, int count,
		    MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_write_all(MPI_File fh, void *buf, int count,
			MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_iread(MPI_File fh, void *buf, int count,
		    MPI_Datatype datatype, MPI_Request *request);
int PMPI_File_iwrite(MPI_File fh, void *buf, int count,
		     MPI_Datatype datatype, MPI_Request *request);
int PMPI_File_seek(MPI_File fh, MPI_Offset offset, int whence);
int PMPI_File_get_position(MPI_File fh, MPI_Offset *offset);
int PMPI_File_get_byte_offset(MPI_File fh, MPI_Offset offset,
			      MPI_Offset *disp);
int PMPI_File_read_shared(MPI_File fh, void *buf, int count,
			  MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_write_shared(MPI_File fh, void *buf, int count,
			   MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_iread_shared(MPI_File fh, void *buf, int count,
			   MPI_Datatype datatype, MPI_Request *request);
int PMPI_File_iwrite_shared(MPI_File fh, void *buf, int count,
			    MPI_Datatype datatype, MPI_Request *request);
int PMPI_File_read_ordered(MPI_File fh, void *buf, int count,
			   MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_write_ordered(MPI_File fh, void *buf, int count,
			    MPI_Datatype datatype, MPI_Status *status);
int PMPI_File_seek_shared(MPI_File fh, MPI_Offset offset, int whence);
int PMPI_File_get_position_shared(MPI_File fh, MPI_Offset *offset);
int PMPI_File_read_at_all_begin(MPI_File fh, MPI_Offset offset, void *buf,
				int count, MPI_Datatype datatype);
int PMPI_File_read_at_all_end(MPI_File fh, void *buf, MPI_Status *status);
int PMPI_File_write_at_all_begin(MPI_File fh, MPI_Offset offset, void *buf,
				 int count, MPI_Datatype datatype);
int PMPI_File_write_at_all_end(MPI_File fh, void *buf, MPI_Status *status);
int PMPI_File_read_all_begin(MPI_File fh, void *buf, int count,
			     MPI_Datatype datatype);
int PMPI_File_read_all_end(MPI_File fh, void *buf, MPI_Status *status);
int PMPI_File_write_all_begin(MPI_File fh, void *buf, int count,
			      MPI_Datatype datatype);
int PMPI_File_write_all_end(MPI_File fh, void *buf, MPI_Status *status);
int PMPI_File_read_ordered_begin(MPI_File fh, void *buf, int count,
				 MPI_Datatype datatype);
int PMPI_File_read_ordered_end(MPI_File fh, void *buf, MPI_Status *status);
int PMPI_File_write_ordered_begin(MPI_File fh, void *buf, int count,
				  MPI_Datatype datatype);
int PMPI_File_write_ordered_end(MPI_File fh, void *buf, MPI_Status *status);
int PMPI_File_get_type_extent(MPI_File fh, MPI_Datatype datatype,
                                             MPI_Aint *extent);
int PMPI_File_set_atomicity(MPI_File fh, int flag);
int PMPI_File_get_atomicity(MPI_File fh, int *flag);
int PMPI_File_sync(MPI_File fh);
int PMPI_Finalize(void);
int PMPI_Finalized(int *flag);
int PMPI_Free_mem(void *base);
int PMPI_Gather(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		void *recvbuf, int recvcount, MPI_Datatype recvtype,
		int root, MPI_Comm comm);
int PMPI_Gatherv(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		 void *recvbuf, int *recvcounts, int *displs,
		 MPI_Datatype recvtype, int root, MPI_Comm comm);
int PMPI_Get_address(void *location, MPI_Aint *address);
int PMPI_Get_count(MPI_Status *status, MPI_Datatype datatype, int *count);
int PMPI_Get_elements(MPI_Status *status, MPI_Datatype datatype,
		      int *count);
int PMPI_Get(void *origin_addr, int origin_count,
	     MPI_Datatype origin_datatype, int target_rank,
	     MPI_Aint target_disp, int target_count,
	     MPI_Datatype target_datatype, MPI_Win win);
int PMPI_Get_processor_name(char *name, int *resultlen);
int PMPI_Get_version(int *version, int *subversion);
int PMPI_Graph_create(MPI_Comm comm_old, int nnodes, int *index,
		      int *edges, int reorder, MPI_Comm *comm_graph);
int PMPI_Graph_get(MPI_Comm comm, int maxindex, int maxedges,
		   int *index, int *edges);
int PMPI_Graph_map(MPI_Comm comm, int nnodes, int *index, int *edges,
		   int *newrank);
int PMPI_Graph_neighbors_count(MPI_Comm comm, int rank, int *nneighbors);
int PMPI_Graph_neighbors(MPI_Comm comm, int rank, int maxneighbors,
			 int *neighbors);
int PMPI_Graphdims_get(MPI_Comm comm, int *nnodes, int *nedges);
int PMPI_Grequest_complete(MPI_Request request);
int PMPI_Grequest_start(MPI_Grequest_query_function *query_fn,
			MPI_Grequest_free_function *free_fn,
			MPI_Grequest_cancel_function *cancel_fn,
			void *extra_state, MPI_Request *request);
MPI_Fint PMPI_Group_c2f(MPI_Group group);
int PMPI_Group_compare(MPI_Group group1, MPI_Group group2, int *result);
int PMPI_Group_difference(MPI_Group group1, MPI_Group group2,
			  MPI_Group *newgroup);
int PMPI_Group_excl(MPI_Group group, int n, int *ranks,
		    MPI_Group *newgroup);
MPI_Group PMPI_Group_f2c(MPI_Fint group);
int PMPI_Group_free(MPI_Group *group);
int PMPI_Group_incl(MPI_Group group, int n, int *ranks,
		    MPI_Group *newgroup);
int PMPI_Group_intersection(MPI_Group group1, MPI_Group group2,
			    MPI_Group *newgroup);
int PMPI_Group_range_excl(MPI_Group group, int n, int ranges[][3],
			  MPI_Group *newgroup);
int PMPI_Group_range_incl(MPI_Group group, int n, int ranges[][3],
			  MPI_Group *newgroup);
int PMPI_Group_rank(MPI_Group group, int *rank);
int PMPI_Group_size(MPI_Group group, int *size);
int PMPI_Group_translate_ranks(MPI_Group group1, int n, int *ranks1,
			       MPI_Group group2, int *ranks2);
int PMPI_Group_union(MPI_Group group1, MPI_Group group2,
		     MPI_Group *newgroup);
int PMPI_Ibsend(void *buf, int count, MPI_Datatype datatype, int dest,
		int tag, MPI_Comm comm, MPI_Request *request);
MPI_Fint PMPI_Info_c2f(MPI_Info info);
int PMPI_Info_create(MPI_Info *info);
int PMPI_Info_delete(MPI_Info info, char *key);
int PMPI_Info_dup(MPI_Info info, MPI_Info *newinfo);
MPI_Info PMPI_Info_f2c(MPI_Fint info);
int PMPI_Info_free(MPI_Info *info);
int PMPI_Info_get(MPI_Info info, char *key, int valuelen,
		  char *value, int *flag);
int PMPI_Info_get_nkeys(MPI_Info info, int *nkeys);
int PMPI_Info_get_nthkey(MPI_Info info, int n, char *key);
int PMPI_Info_get_valuelen(MPI_Info info, char *key, int *valuelen,
			   int *flag);
int PMPI_Info_set(MPI_Info info, char *key, char *value);
int PMPI_Init(int *argc, char ***argv);
int PMPI_Initialized(int *flag);
int PMPI_Init_thread(int *argc, char ***argv, int required,
		     int *provided);
int PMPI_Intercomm_create(MPI_Comm local_comm, int local_leader,
			  MPI_Comm bridge_comm, int remote_leader,
			  int tag, MPI_Comm *newintercomm);
int PMPI_Intercomm_merge(MPI_Comm intercomm, int high,
			 MPI_Comm *newintercomm);
int PMPI_Iprobe(int source, int tag, MPI_Comm comm, int *flag,
		MPI_Status *status);
int PMPI_Irecv(void *buf, int count, MPI_Datatype datatype, int source,
	       int tag, MPI_Comm comm, MPI_Request *request);
int PMPI_Irsend(void *buf, int count, MPI_Datatype datatype, int dest,
		int tag, MPI_Comm comm, MPI_Request *request);
int PMPI_Isend(void *buf, int count, MPI_Datatype datatype, int dest,
	       int tag, MPI_Comm comm, MPI_Request *request);
int PMPI_Issend(void *buf, int count, MPI_Datatype datatype, int dest,
		int tag, MPI_Comm comm, MPI_Request *request);
int PMPI_Is_thread_main(int *flag);
int PMPI_Lookup_name(char *service_name, MPI_Info info, char *port_name);
MPI_Fint PMPI_Op_c2f(MPI_Op op);
int PMPI_Op_commutative(MPI_Op op, int *commute);
int PMPI_Op_create(MPI_User_function *func, int commute, MPI_Op *op);
int PMPI_Open_port(MPI_Info info, char *port_name);
MPI_Op PMPI_Op_f2c(MPI_Fint op);
int PMPI_Op_free(MPI_Op *op);
int PMPI_Pack_external(char *datarep, void *inbuf, int incount,
		       MPI_Datatype datatype, void *outbuf,
		       MPI_Aint outsize, MPI_Aint *position);
int PMPI_Pack_external_size(char *datarep, int incount,
			    MPI_Datatype datatype, MPI_Aint *size);
int PMPI_Pack(void *inbuf, int incount, MPI_Datatype datatype,
	      void *outbuf, int outsize, int *position, MPI_Comm comm);
int PMPI_Pack_size(int incount, MPI_Datatype datatype, MPI_Comm comm,
		   int *size);
int PMPI_Pcontrol(const int level, ...);
int PMPI_Probe(int source, int tag, MPI_Comm comm, MPI_Status *status);
int PMPI_Publish_name(char *service_name, MPI_Info info,
                                     char *port_name);
int PMPI_Put(void *origin_addr, int origin_count, MPI_Datatype origin_datatype,
	     int target_rank, MPI_Aint target_disp, int target_count,
	     MPI_Datatype target_datatype, MPI_Win win);
int PMPI_Query_thread(int *provided);
int PMPI_Recv_init(void *buf, int count, MPI_Datatype datatype, int source,
		   int tag, MPI_Comm comm, MPI_Request *request);
int PMPI_Recv(void *buf, int count, MPI_Datatype datatype, int source,
	      int tag, MPI_Comm comm, MPI_Status *status);
int PMPI_Reduce(void *sendbuf, void *recvbuf, int count,
		MPI_Datatype datatype, MPI_Op op, int root, MPI_Comm comm);
int PMPI_Reduce_local(void *inbuf, void *inoutbuf, int count,
		      MPI_Datatype datatype, MPI_Op);
int PMPI_Reduce_scatter(void *sendbuf, void *recvbuf, int *recvcounts,
			MPI_Datatype datatype, MPI_Op op, MPI_Comm comm);
int PMPI_Register_datarep(char *datarep,
			  MPI_Datarep_conversion_function *read_conversion_fn,
			  MPI_Datarep_conversion_function *write_conversion_fn,
			  MPI_Datarep_extent_function *dtype_file_extent_fn,
			  void *extra_state);
MPI_Fint PMPI_Request_c2f(MPI_Request request);
MPI_Request PMPI_Request_f2c(MPI_Fint request);
int PMPI_Request_free(MPI_Request *request);
int PMPI_Request_get_status(MPI_Request request, int *flag,
			    MPI_Status *status);
int PMPI_Rsend(void *ibuf, int count, MPI_Datatype datatype, int dest,
	       int tag, MPI_Comm comm);
int PMPI_Rsend_init(void *buf, int count, MPI_Datatype datatype,
		    int dest, int tag, MPI_Comm comm,
		    MPI_Request *request);
int PMPI_Scan(void *sendbuf, void *recvbuf, int count,
	      MPI_Datatype datatype, MPI_Op op, MPI_Comm comm);
int PMPI_Scatter(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		 void *recvbuf, int recvcount, MPI_Datatype recvtype,
		 int root, MPI_Comm comm);
int PMPI_Scatterv(void *sendbuf, int *sendcounts, int *displs,
		  MPI_Datatype sendtype, void *recvbuf, int recvcount,
		  MPI_Datatype recvtype, int root, MPI_Comm comm);
int PMPI_Send_init(void *buf, int count, MPI_Datatype datatype,
		   int dest, int tag, MPI_Comm comm,
		   MPI_Request *request);
int PMPI_Send(void *buf, int count, MPI_Datatype datatype, int dest,
	      int tag, MPI_Comm comm);
int PMPI_Sendrecv(void *sendbuf, int sendcount, MPI_Datatype sendtype,
		  int dest, int sendtag, void *recvbuf, int recvcount,
		  MPI_Datatype recvtype, int source, int recvtag,
		  MPI_Comm comm,  MPI_Status *status);
int PMPI_Sendrecv_replace(void * buf, int count, MPI_Datatype datatype,
			  int dest, int sendtag, int source, int recvtag,
			  MPI_Comm comm, MPI_Status *status);
int PMPI_Ssend_init(void *buf, int count, MPI_Datatype datatype,
		    int dest, int tag, MPI_Comm comm,
		    MPI_Request *request);
int PMPI_Ssend(void *buf, int count, MPI_Datatype datatype, int dest,
	       int tag, MPI_Comm comm);
int PMPI_Start(MPI_Request *request);
int PMPI_Startall(int count, MPI_Request *array_of_requests);
int PMPI_Status_c2f(MPI_Status *c_status, MPI_Fint *f_status);
int PMPI_Status_f2c(MPI_Fint *f_status, MPI_Status *c_status);
int PMPI_Status_set_cancelled(MPI_Status *status, int flag);
int PMPI_Status_set_elements(MPI_Status *status, MPI_Datatype datatype,
			     int count);
int PMPI_Testall(int count, MPI_Request array_of_requests[], int *flag,
		 MPI_Status array_of_statuses[]);
int PMPI_Testany(int count, MPI_Request array_of_requests[], int *index, int *flag, MPI_Status *status);
int PMPI_Test(MPI_Request *request, int *flag, MPI_Status *status);
int PMPI_Test_cancelled(MPI_Status *status, int *flag);
int PMPI_Testsome(int incount, MPI_Request array_of_requests[],
		  int *outcount, int array_of_indices[],
		  MPI_Status array_of_statuses[]);
int PMPI_Topo_test(MPI_Comm comm, int *status);
MPI_Fint PMPI_Type_c2f(MPI_Datatype datatype);
int PMPI_Type_commit(MPI_Datatype *type);
int PMPI_Type_contiguous(int count, MPI_Datatype oldtype,
			 MPI_Datatype *newtype);
int PMPI_Type_create_darray(int size, int rank, int ndims,
			    int gsize_array[], int distrib_array[],
			    int darg_array[], int psize_array[],
			    int order, MPI_Datatype oldtype,
			    MPI_Datatype *newtype);
int PMPI_Type_create_f90_complex(int p, int r, MPI_Datatype *newtype);
int PMPI_Type_create_f90_integer(int r, MPI_Datatype *newtype);
int PMPI_Type_create_f90_real(int p, int r, MPI_Datatype *newtype);
int PMPI_Type_create_hindexed(int count, int array_of_blocklengths[],
			      MPI_Aint array_of_displacements[],
			      MPI_Datatype oldtype,
			      MPI_Datatype *newtype);
int PMPI_Type_create_hvector(int count, int blocklength, MPI_Aint stride,
			     MPI_Datatype oldtype,
			     MPI_Datatype *newtype);
int PMPI_Type_create_keyval(MPI_Type_copy_attr_function *type_copy_attr_fn,
			    MPI_Type_delete_attr_function *type_delete_attr_fn,
			    int *type_keyval, void *extra_state);
int PMPI_Type_create_indexed_block(int count, int blocklength,
				   int array_of_displacements[],
				   MPI_Datatype oldtype,
				   MPI_Datatype *newtype);
int PMPI_Type_create_struct(int count, int array_of_block_lengths[],
			    MPI_Aint array_of_displacements[],
			    MPI_Datatype array_of_types[],
			    MPI_Datatype *newtype);
int PMPI_Type_create_subarray(int ndims, int size_array[], int subsize_array[],
			      int start_array[], int order,
			      MPI_Datatype oldtype, MPI_Datatype *newtype);
int PMPI_Type_create_resized(MPI_Datatype oldtype, MPI_Aint lb,
			     MPI_Aint extent, MPI_Datatype *newtype);
int PMPI_Type_delete_attr(MPI_Datatype type, int type_keyval);
int PMPI_Type_dup(MPI_Datatype type, MPI_Datatype *newtype);
int PMPI_Type_free(MPI_Datatype *type);
int PMPI_Type_free_keyval(int *type_keyval);
MPI_Datatype PMPI_Type_f2c(MPI_Fint datatype);
int PMPI_Type_get_attr(MPI_Datatype type, int type_keyval,
		       void *attribute_val, int *flag);
int PMPI_Type_get_contents(MPI_Datatype mtype, int max_integers,
			   int max_addresses, int max_datatypes,
			   int array_of_integers[],
			   MPI_Aint array_of_addresses[],
			   MPI_Datatype array_of_datatypes[]);
int PMPI_Type_get_envelope(MPI_Datatype type, int *num_integers,
			   int *num_addresses, int *num_datatypes,
			   int *combiner);
int PMPI_Type_get_extent(MPI_Datatype type, MPI_Aint *lb,
			 MPI_Aint *extent);
int PMPI_Type_get_name(MPI_Datatype type, char *type_name,
		       int *resultlen);
int PMPI_Type_get_true_extent(MPI_Datatype datatype, MPI_Aint *true_lb,
			      MPI_Aint *true_extent);
int PMPI_Type_indexed(int count, int array_of_blocklengths[],
		      int array_of_displacements[],
		      MPI_Datatype oldtype, MPI_Datatype *newtype);
int PMPI_Type_match_size(int typeclass, int size, MPI_Datatype *type);
int PMPI_Type_set_attr(MPI_Datatype type, int type_keyval,
		       void *attr_val);
int PMPI_Type_set_name(MPI_Datatype type, char *type_name);
int PMPI_Type_size(MPI_Datatype type, int *size);
int PMPI_Type_vector(int count, int blocklength, int stride,
		     MPI_Datatype oldtype, MPI_Datatype *newtype);
int PMPI_Unpack(void *inbuf, int insize, int *position,
		void *outbuf, int outcount, MPI_Datatype datatype,
		MPI_Comm comm);
int PMPI_Unpublish_name(char *service_name, MPI_Info info,
			char *port_name);
int PMPI_Unpack_external (char *datarep, void *inbuf, MPI_Aint insize,
			  MPI_Aint *position, void *outbuf, int outcount,
			  MPI_Datatype datatype);
int PMPI_Waitall(int count, MPI_Request *array_of_requests,
		 MPI_Status *array_of_statuses);
int PMPI_Waitany(int count, MPI_Request *array_of_requests,
		 int *index, MPI_Status *status);
int PMPI_Wait(MPI_Request *request, MPI_Status *status);
int PMPI_Waitsome(int incount, MPI_Request *array_of_requests,
		  int *outcount, int *array_of_indices,
		  MPI_Status *array_of_statuses);
MPI_Fint PMPI_Win_c2f(MPI_Win win);
int PMPI_Win_call_errhandler(MPI_Win win, int errorcode);
int PMPI_Win_complete(MPI_Win win);
int PMPI_Win_create(void *base, MPI_Aint size, int disp_unit,
		    MPI_Info info, MPI_Comm comm, MPI_Win *win);
int PMPI_Win_create_errhandler(MPI_Win_errhandler_function *func,
			       MPI_Errhandler *errhandler);
int PMPI_Win_create_keyval(MPI_Win_copy_attr_function *win_copy_attr_fn,
			   MPI_Win_delete_attr_function *win_delete_attr_fn,
			   int *win_keyval, void *extra_state);
int PMPI_Win_delete_attr(MPI_Win win, int win_keyval);
MPI_Win PMPI_Win_f2c(MPI_Fint win);
int PMPI_Win_fence(int assert, MPI_Win win);
int PMPI_Win_free(MPI_Win *win);
int PMPI_Win_free_keyval(int *win_keyval);
int PMPI_Win_get_attr(MPI_Win win, int win_keyval,
		      void *attribute_val, int *flag);
int PMPI_Win_get_errhandler(MPI_Win win, MPI_Errhandler *errhandler);
int PMPI_Win_get_group(MPI_Win win, MPI_Group *group);
int PMPI_Win_get_name(MPI_Win win, char *win_name, int *resultlen);
int PMPI_Win_lock(int lock_type, int rank, int assert, MPI_Win win);
int PMPI_Win_post(MPI_Group group, int assert, MPI_Win win);
int PMPI_Win_set_attr(MPI_Win win, int win_keyval, void *attribute_val);
int PMPI_Win_set_errhandler(MPI_Win win, MPI_Errhandler errhandler);
int PMPI_Win_set_name(MPI_Win win, char *win_name);
int PMPI_Win_start(MPI_Group group, int assert, MPI_Win win);
int PMPI_Win_test(MPI_Win win, int *flag);
int PMPI_Win_unlock(int rank, MPI_Win win);
int PMPI_Win_wait(MPI_Win win);
double PMPI_Wtick(void);
double PMPI_Wtime(void);


      ]]

   end

end

------------------------------------------------------------------------------
