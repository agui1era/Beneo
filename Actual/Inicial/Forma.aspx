<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="Forma.aspx.cs" Inherits="WEB.Forma" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <link rel="stylesheet" href="../AdminLte/plugins/fullcalendar/main.min.css" />
    <link rel="stylesheet" href="../AdminLte/plugins/fullcalendar-daygrid/main.min.css" />
    <link rel="stylesheet" href="../AdminLte/plugins/fullcalendar-timegrid/main.min.css" />
    <link rel="stylesheet" href="../AdminLte/plugins/fullcalendar-bootstrap/main.min.css" />
    <script src="../AdminLte/plugins/fullcalendar/main.min.js"></script>
    <script src="../AdminLte/plugins/fullcalendar-daygrid/main.min.js"></script>
    <script src="../AdminLte/plugins/fullcalendar-timegrid/main.min.js"></script>
    <script src="../AdminLte/plugins/fullcalendar-interaction/main.min.js"></script>
    <script src="../AdminLte/plugins/fullcalendar-bootstrap/main.min.js"></script>
  <%--  <script>
        $(function () {
            /* initialize the calendar
             -----------------------------------------------------------------*/
            //Date for the calendar events (dummy data)
            var date = new Date()
            var d = date.getDate(),
                m = date.getMonth(),
                y = date.getFullYear()

            var Calendar = FullCalendar.Calendar;
            var calendarEl = document.getElementById('calendar');

            // initialize the external events
            // -----------------------------------------------------------------
            var calendar = new Calendar(calendarEl, {
                plugins: ['bootstrap', 'interaction', 'dayGrid', 'timeGrid'],
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                locale: 'es',
                firstDay: 1,
                buttonText: {
                    today: 'Hoy',
                    month: 'Mes',
                    week: 'Semana',
                    day: 'Día',
                    list: 'Lista'
                },
                'themeSystem': 'bootstrap',
                //Random default events
                //events: [
                //  {
                //      title: 'All Day Event',
                //      start: new Date(y, m, 1),
                //      backgroundColor: '#f56954', //red
                //      borderColor: '#f56954', //red
                //      allDay: true
                //  },
                //  {
                //      title: 'Long Event',
                //      start: new Date(y, m, d - 5),
                //      end: new Date(y, m, d - 2),
                //      backgroundColor: '#f39c12', //yellow
                //      borderColor: '#f39c12' //yellow
                //  },
                //  {
                //      title: 'Meeting',
                //      start: new Date(y, m, d, 10, 30),
                //      allDay: false,
                //      backgroundColor: '#0073b7', //Blue
                //      borderColor: '#0073b7' //Blue
                //  },
                //  {
                //      title: 'Lunch',
                //      start: new Date(y, m, d, 12, 0),
                //      end: new Date(y, m, d, 14, 0),
                //      allDay: false,
                //      backgroundColor: '#00c0ef', //Info (aqua)
                //      borderColor: '#00c0ef' //Info (aqua)
                //  },
                //  {
                //      title: 'Birthday Party',
                //      start: new Date(y, m, d + 1, 19, 0),
                //      end: new Date(y, m, d + 1, 22, 30),
                //      allDay: false,
                //      backgroundColor: '#00a65a', //Success (green)
                //      borderColor: '#00a65a' //Success (green)
                //  },
                //  {
                //      title: 'Click for Google',
                //      start: new Date(y, m, 28),
                //      end: new Date(y, m, 29),
                //      backgroundColor: '#3c8dbc', //Primary (light-blue)
                //      borderColor: '#3c8dbc' //Primary (light-blue)
                //  }
                //],
                editable: false,
                droppable: false, // this allows things to be dropped onto the calendar !!!
            });
            calendar.render();
            // $('#calendar').fullCalendar()
        })
    </script>--%>
      <script>
        $(function () {

            $("#<%= dtgPrincipal.ClientID %>").DataTable({
              "responsive": true,
              "autoWidth": false
            });
        })
    </script>

    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Dashboard</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item active">Dashboard</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Small boxes (Stat box) -->
    <div class="row ">
        <div class=" col-lg-3 col-6">
            <!-- small box -->
            <div class="small-box bg-info">
                <div class="inner">
                    <h3>
                        <asp:Label ID="lblTotalActividad" runat="server" Text="Label"></asp:Label></h3>

                    <p>Total Actividades del mes</p>
                </div>
                <div class="icon">
                    <i class="ion ion-stats-bars"></i>
                </div>
                <asp:LinkButton ID="btnTotalActividades" runat="server" CssClass="small-box-footer" Text="Más Información " OnClick="btnTotalActividades_Click" />
                <%--<button type="button" runat="server" class="btn btn-primary btn-block" onclick="btnTotalActividades_onclick">Mas información <i class="fas fa-arrow-circle-right"></i></button>--%>
                <%--<a href="#" class="small-box-footer">Mas información <i class="fas fa-arrow-circle-right"></i></a>--%>
            </div>
        </div>
        <!-- ./col -->
        <div class=" col-lg-3 col-6 ">
            <!-- small box -->
            <div class="small-box bg-danger">
                <div class="inner">
                    <h3>
                        <asp:Label ID="lblActRetrasados" runat="server" Text="Label"></asp:Label></h3>
                    <p>Actividades Atrasadas</p>
                </div>
                <div class="icon">
                    <i class="ion ion-clock"></i>
                </div>
                <asp:LinkButton ID="btnActividadesAtrasadas" runat="server" CssClass="small-box-footer" Text="Más Información" OnClick="btnActividadesAtrasadas_Click" />
                <%--<a href="#" class="small-box-footer">Mas información <i class="fas fa-arrow-circle-right"></i></a>--%>
            </div>
        </div>
        <!-- ./col -->
        <div class="col-lg-3 col-6">
            <!-- small box -->
            <div class="small-box bg-success">
                <div class="inner">
                    <h3>
                        <asp:Label ID="lblActTerminadas" runat="server" Text="Label"></asp:Label></h3>

                    <p>Actividades Terminadas</p>
                </div>
                <div class="icon">
                    <i class="ion ion-flag"></i>
                </div>
                <asp:LinkButton ID="btnActividadesTerminadas" runat="server" CssClass="small-box-footer" Text="Más Información" OnClick="btnActividadesTerminadas_Click" />
                <%--<a href="#" class="small-box-footer">Mas información <i class="fas fa-arrow-circle-right"></i></a>--%>
            </div>
        </div>
        <!-- ./col -->
        <div class="col-lg-3 col-6">
            <!-- small box -->
            <div class="small-box bg-warning">
                <div class="inner">
                    <h3>
                        <asp:Label ID="lblActCanceladas" runat="server" Text="Label"></asp:Label></h3>

                    <p>Actividades Canceladas</p>
                </div>
                <div class="icon">
                    <i class="ion ion-flame"></i>
                </div>
                <asp:LinkButton ID="btnActividadesCanceladas" runat="server" CssClass="small-box-footer" Text="Más Información" OnClick="btnActividadesCanceladas_Click" />
                <%--<a href="#" class="small-box-footer">Mas información <i class="fas fa-arrow-circle-right"></i></a>--%>
            </div>
        </div>
        <!-- ./col -->
    </div>
    <div class="row ">
        <div class=" col-lg-3 col-6">
            <!-- small box -->
            <div class="small-box bg-gradient-blue">
                <div class="inner">
                    <h3>
                        <asp:Label ID="lblActividadesFuturas" runat="server" Text="Label"></asp:Label></h3>

                    <p>Actividades Futuras</p>
                </div>
                <div class="icon">
                    <i class="ion ion-arrow-right-a"></i>
                </div>
                <asp:LinkButton ID="lnkFuturas" runat="server" CssClass="small-box-footer" Text="Más Información " OnClick="lnkFuturas_Click" />
                <%--<button type="button" runat="server" class="btn btn-primary btn-block" onclick="btnTotalActividades_onclick">Mas información <i class="fas fa-arrow-circle-right"></i></button>--%>
                <%--<a href="#" class="small-box-footer">Mas información <i class="fas fa-arrow-circle-right"></i></a>--%>
            </div>
        </div>
         <div class=" col-lg-3 col-6 ">
            <!-- small box -->
            <div class="small-box bg-gradient-gray">
                <div class="inner">
                    <h3><asp:Label ID="lblProdAcabar" runat="server" Text="0"></asp:Label></h3>
                    <p>Productos con bajo stock</p>
                </div>
                <div class="icon">
                    <i class="ion ion-scissors"></i>
                </div>
                <asp:LinkButton ID="lnkProdAcabar" runat="server" CssClass="small-box-footer" Text="Más Información" OnClick="lnkProdAcabar_Click"  />
                <%--<a href="#" class="small-box-footer">Mas información <i class="fas fa-arrow-circle-right"></i></a>--%>
            </div>
        </div>
        <div class="col-lg-3 col-6">
            <!-- small box -->
            <div class="small-box bg-gradient-orange">
                <div class="inner">
                    <h3>
                        <asp:Label ID="lblProductosVencer" runat="server" Text="0"></asp:Label></h3>

                    <p>Productos por Vencer (a 3 Meses)</p>
                </div>
                <div class="icon">
                    <i class="ion ion-alert-circled"></i>
                </div>
                <asp:LinkButton ID="lnkProductosVencer" runat="server" CssClass="small-box-footer" Text="Más Información" OnClick="lnkProductosVencer_Click"  />
                <%--<a href="#" class="small-box-footer">Mas información <i class="fas fa-arrow-circle-right"></i></a>--%>
            </div>
        </div>
        <div class=" col-lg-3 col-6 ">
            <!-- small box -->
            <div class="small-box bg-gradient-danger    ">
                <div class="inner">
                    <h3>
                        <asp:Label ID="lblProductosVencidos" runat="server" Text="0"></asp:Label></h3>
                    <p>Productos Vencidos</p>
                </div>
                <div class="icon">
                    <i class="ion ion-trash-a"></i>
                </div>
                <asp:LinkButton ID="lnkProductosVencidos" runat="server" CssClass="small-box-footer" Text="Más Información" OnClick="lnkProductosVencidos_Click"  />
                <%--<a href="#" class="small-box-footer">Mas información <i class="fas fa-arrow-circle-right"></i></a>--%>
            </div>
        </div>

    </div>
    <!-- /.row -->
    <!-- Main row -->
    <div class="row">

        <!-- Left col -->
        <section class=" col-lg-12">
            <!-- Custom tabs (Charts with tabs)-->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-calendar-alt mr-1"></i>
                        Ensayos
                    </h3>
                </div>

                <!-- /.card-header -->
                <div class="row">
                    <!-- /.col -->
                    <div class="col-md-12">
                        <div class="card card-primary">
                            <div class="card-body p-0">

                                <%--<asp:Calendar ID="calPpal" runat="server" Width="100%"></asp:Calendar>--%>
                                <!-- THE CALENDAR -->
                                <div id="calendar"></div>
                            </div>
                            <!-- /.card-body -->
                        </div>
                        <!-- /.card -->
                    </div>
                    <!-- /.col -->
                </div>
                <!-- /.row -->
            </div>
            <!-- /.card -->
        </section>
        <!-- /.container-fluid -->
        <!-- /.Left col -->
    </div>
    <!-- /.row (main row) -->
    <!-- /.content -->
    <!-- /.content-wrapper -->

    <div class="modal" id="dashAct" tabindex="-1" role="dialog" aria-labelledby="DetalleASignacionLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Tareas Pendientes</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">


                    <asp:GridView ID="dtgPrincipal" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" PageSize="20" OnDataBound="dtgPrincipal_DataBound" OnRowCreated="dtgPrincipal_RowCreated">
                        <Columns>
                            <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                            <asp:BoundField DataField="Nombre" HeaderText="Temporada" />
                            <asp:BoundField DataField="CodEns" HeaderText="Ensayo" />
                            <asp:BoundField DataField="CodLugar" HeaderText="Lugar" />
                            <asp:BoundField DataField="Actividad" HeaderText="Actividad" />
                            <asp:BoundField DataField="Dia" HeaderText="Día" />
                            <asp:BoundField DataField="FechaDia" HeaderText="Fecha" DataFormatString="{0:d}" />
                            <%--  <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnModificar" class="btn btn-success" runat="server" Text="Modificar" CommandName="Modificar" CommandArgument='<%#Eval("Id") %>'></asp:Button>
                        </ItemTemplate>
                    </asp:TemplateField>--%>
                            <%--<asp:ButtonField ButtonType="Button" HeaderText="Modificar" Text="modificar">
                        <ControlStyle CssClass="btn btn-primary" />
                    </asp:ButtonField>--%>
                        </Columns>
                        <PagerStyle CssClass="pagination pagination-sm float-right" />
                    </asp:GridView>

                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnModalGuardar" runat="server" Text="Ir a Revisar" CssClass="btn btn-primary" OnClick="btnModalGuardar_Click" />
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="modal-TotalActividades" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Total Actividades</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 col-sm-12">
                            <asp:GridView ID="dtgTotalActividades" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" PageSize="20" OnDataBound="dtgTotalActividades_DataBound" OnRowCreated="dtgTotalActividades_RowCreated">
                                <Columns>
                                    <asp:BoundField DataField="Nombre" HeaderText="Temporada" />
                                    <asp:BoundField DataField="CodEns" HeaderText="Ensayo" />
                                    <asp:BoundField DataField="CodLugar" HeaderText="Lugar" />
                                    <asp:BoundField DataField="Actividad" HeaderText="Actividad" />
                                    <asp:BoundField DataField="Dia" HeaderText="Día" />
                                    <asp:BoundField DataField="FechaDia" HeaderText="Fecha" DataFormatString="{0:d}" />
                                </Columns>
                                <PagerStyle CssClass="pagination pagination-sm float-right" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <div class="modal fade" id="modal-ActividadesAtrasadas" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Actividades Atrasadas</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 col-sm-12">
                            <asp:GridView ID="dtgActividadesAtrasadas" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" PageSize="20" OnDataBound="dtgActividadesAtrasadas_DataBound" OnRowCreated="dtgActividadesAtrasadas_RowCreated">
                                <Columns>
                                    <asp:BoundField DataField="Nombre" HeaderText="Temporada" />
                                    <asp:BoundField DataField="CodEns" HeaderText="Ensayo" />
                                    <asp:BoundField DataField="CodLugar" HeaderText="Lugar" />
                                    <asp:BoundField DataField="Actividad" HeaderText="Actividad" />
                                    <asp:BoundField DataField="Dia" HeaderText="Día" />
                                    <asp:BoundField DataField="FechaDia" HeaderText="Fecha" DataFormatString="{0:d}" />
                                </Columns>
                                <PagerStyle CssClass="pagination pagination-sm float-right" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <div class="modal fade" id="modal-ActividadesTerminadas" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Actividades Terminadas</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 col-sm-12">
                            <asp:GridView ID="dtgActividadesTerminadas" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" PageSize="20" OnDataBound="dtgActividadesTerminadas_DataBound" OnRowCreated="dtgActividadesTerminadas_RowCreated">
                                <Columns>
                                    <asp:BoundField DataField="Nombre" HeaderText="Temporada" />
                                    <asp:BoundField DataField="CodEns" HeaderText="Ensayo" />
                                    <asp:BoundField DataField="CodLugar" HeaderText="Lugar" />
                                    <asp:BoundField DataField="Actividad" HeaderText="Actividad" />
                                    <asp:BoundField DataField="Dia" HeaderText="Día" />
                                    <asp:BoundField DataField="FechaDia" HeaderText="Fecha" DataFormatString="{0:d}" />
                                </Columns>
                                <PagerStyle CssClass="pagination pagination-sm float-right" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <div class="modal fade" id="modal-ActividadesCanceladas" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Actividades Canceladas</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 col-sm-12">
                            <asp:GridView ID="dtgActividadesCanceladas" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" PageSize="20" OnDataBound="dtgActividadesCanceladas_DataBound" OnRowCreated="dtgActividadesCanceladas_RowCreated">
                                <Columns>
                                    <asp:BoundField DataField="Nombre" HeaderText="Temporada" />
                                    <asp:BoundField DataField="CodEns" HeaderText="Ensayo" />
                                    <asp:BoundField DataField="CodLugar" HeaderText="Lugar" />
                                    <asp:BoundField DataField="Actividad" HeaderText="Actividad" />
                                    <asp:BoundField DataField="Dia" HeaderText="Día" />
                                    <asp:BoundField DataField="FechaDia" HeaderText="Fecha" DataFormatString="{0:d}" />
                                </Columns>
                                <PagerStyle CssClass="pagination pagination-sm float-right" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    
    <div class="modal fade" id="modal-Futura" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Actividades Futuras</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 col-sm-12">
                            <asp:GridView ID="dtgActividadesFuturas" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" PageSize="20" OnDataBound="dtgActividadesFuturas_DataBound" OnRowCreated="dtgActividadesFuturas_RowCreated">
                                <Columns>
                                    <asp:BoundField DataField="Nombre" HeaderText="Temporada" />
                                    <asp:BoundField DataField="CodEns" HeaderText="Ensayo" />
                                    <asp:BoundField DataField="CodLugar" HeaderText="Lugar" />
                                    <asp:BoundField DataField="Actividad" HeaderText="Actividad" />
                                    <asp:BoundField DataField="Dia" HeaderText="Día" />
                                    <asp:BoundField DataField="FechaDia" HeaderText="Fecha" DataFormatString="{0:d}" />
                                </Columns>
                                <PagerStyle CssClass="pagination pagination-sm float-right" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    
    <div class="modal fade" id="modal-Producto" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><asp:Label ID="lblTituloProdModal" runat="server" Text="Label"></asp:Label></h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 col-sm-12">
                            <asp:GridView ID="dtgProdModal" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" PageSize="20" OnDataBound="dtgActividadesFuturas_DataBound" OnRowCreated="dtgActividadesFuturas_RowCreated">
                                <Columns>
                                    <asp:BoundField DataField="Codigo" HeaderText="Código" />
                                    <asp:BoundField DataField="Descripcion" HeaderText="Producto" />
                                    <asp:BoundField DataField="Categoria" HeaderText="Categoría" />
                                    <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" DataFormatString="{0:#,##0.##}" />
                                    <asp:BoundField DataField="Limite" HeaderText="Límite" DataFormatString="{0:#,##0.##}" />
                                </Columns>
                                <PagerStyle CssClass="pagination pagination-sm float-right" />
                            </asp:GridView>
                            <asp:GridView ID="dtgProdVctoModal" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" PageSize="20" OnDataBound="dtgActividadesFuturas_DataBound" OnRowCreated="dtgActividadesFuturas_RowCreated">
                                <Columns>
                                    <asp:BoundField DataField="Codigo" HeaderText="Código" />
                                    <asp:BoundField DataField="Descripcion" HeaderText="Producto" />
                                    <asp:BoundField DataField="Categoria" HeaderText="Categoría" />
                                    <asp:BoundField DataField="FechaVcto" HeaderText="Fecha Vcto" DataFormatString="{0:d}" />
                                    <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" DataFormatString="{0:#,##0.##}" />
                                </Columns>
                                <PagerStyle CssClass="pagination pagination-sm float-right" />
                            </asp:GridView>

                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>

