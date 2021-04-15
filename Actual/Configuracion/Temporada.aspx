<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Maestro.Master" AutoEventWireup="true" CodeBehind="Temporada.aspx.cs" Inherits="WEB.Temporada" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"> 
    <script>
        $(function () {
            $("#<%= txtFechaDesde.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })
            $("#<%= txtFechaHasta.ClientID %>").inputmask('dd/mm/yyyy', { 'placeholder': 'dd/mm/yyyy' })

            
    $("#<%= dtgTemporada.ClientID %>").DataTable({
      "responsive": true,
      "autoWidth": false
    });

            //$(document).ready(function () {
            //    //$.validator.setDefaults({
            //    //    submitHandler: function () {
            //    //        alert("Form successful submitted!");
            //    //    }
            //    //});
            //    $('#ctl01').validate({
            //        rules: {
            //            email: {
            //                required: true,
            //                email: true,
            //            },
            //            password: {
            //                required: true,
            //                minlength: 5
            //            },
            //            terms: {
            //                required: true
            //            },
            //        },
            //        messages: {
            //            email: {
            //                required: "Please enter a email address",
            //                email: "Please enter a vaild email address"
            //            },
            //            password: {
            //                required: "Please provide a password",
            //                minlength: "Your password must be at least 5 characters long"
            //            },
            //            terms: "Please accept our terms"
            //        },
            //        errorElement: 'span',
            //        errorPlacement: function (error, element) {
            //            error.addClass('invalid-feedback');
            //            element.closest('.form-group').append(error);
            //        },
            //        highlight: function (element, errorClass, validClass) {
            //            $(element).addClass('is-invalid');
            //        },
            //        unhighlight: function (element, errorClass, validClass) {
            //            $(element).removeClass('is-invalid');
            //        }
            //    });
            //});

        })
    </script>
  
    <div class="col-sm-6">
        <h1 class="m-0 text-dark">Temporada</h1>
    </div>
    <!-- /.col -->
    <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="../Inicial/Forma.aspx">Inicio</a></li>
            <li class="breadcrumb-item active">Temporada</li>
        </ol>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="card card-default">
        <div class="card-header">
            <h3 class="card-title">Actualización de Temporadas</h3>

            <div class="card-tools">
                <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></button>
            </div>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <div class="row">
                <div class="form-group col-md-12 col-sm-12">
                    <label for="txtNombre">Nombre</label>
                    <asp:TextBox ID="txtNombre" name="txtNombre"  runat="server" class="form-control" placeholder="Nombre" autocomplete="off"></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="form-group col-md-6 col-sm-6">
                    <label>Fecha Desde</label>

                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">
                                <i class="far fa-calendar-alt"></i>
                            </span>
                        </div>
                        <asp:TextBox ID="txtFechaDesde" CssClass="form-control" runat="server" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false" autocomplete="off"></asp:TextBox>
                    </div>
                    <!-- /.input group -->
                </div>

                <div class="form-group col-md-6 col-sm-6">
                    <label>Fecha Hasta</label>

                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text">
                                <i class="far fa-calendar-alt"></i>
                            </span>
                        </div>
                        <asp:TextBox ID="txtFechaHasta" CssClass="form-control" runat="server" data-inputmask-alias="datetime" data-inputmask-inputformat="dd/mm/yyyy" data-mask="datemask" im-insert="false" autocomplete="off"></asp:TextBox>
                    </div>
                    <!-- /.input group -->
                </div>
            </div>
            <div class="row">
                <div class="form-group">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="chkActivo" runat="server" />
                        <%--<asp:CheckBox ID="chkActivo" runat="server" class="form-check-input" />--%>
                        <label for="chkActivo" class="form-check-label">Activo</label>
                    </div>
                </div>
            </div>
            <!-- /.row -->
        </div>
        <!-- /.card-body -->
        <div class="card-footer">
            
        <asp:Button ID="btnGuardar" runat="server" class="btn btn-primary" Text="Guardar" OnClick="btnGuardar_Click" />
        <asp:Button ID="btnEliminar" runat="server" class="btn btn-danger" Text="Eliminar" OnClick="btnEliminar_Click" />
        <asp:Button ID="btnNuevo" runat="server" class="btn btn-info" Text="Nuevo" OnClick="btnNuevo_Click" />
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Consulta de Temporadas</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body">
            <asp:GridView ID="dtgTemporada" CssClass="table table-bordered table-striped dataTable dtr-inline" role="grid" DataKeyNames="ID" runat="server" AutoGenerateColumns="False" AllowPaging="True" PageSize="20" OnPageIndexChanging="dtgTemporada_PageIndexChanging" OnRowCommand="dtgTemporada_RowCommand" OnDataBound="dtgTemporada_DataBound" OnRowCreated="dtgTemporada_RowCreated">
                <Columns>
                    <%--<asp:BoundField HeaderText="#" DataField="Numero">
                        <ItemStyle Width="20px" />
                    </asp:BoundField>--%>
                    <asp:BoundField DataField="Id" HeaderText="Id" Visible="false" />
                    <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                    <asp:BoundField DataField="FechaDesde" HeaderText="FechaDesde" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="FechaHasta" HeaderText="FechaHasta" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:CheckBoxField DataField="Activo" HeaderText="Activo" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnModificar" class="btn btn-success" runat="server" Text="Modificar" CommandName="Modificar" CommandArgument='<%#Eval("Id") %>'></asp:Button>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <%--<asp:ButtonField ButtonType="Button" HeaderText="Modificar" Text="modificar">
                        <ControlStyle CssClass="btn btn-primary" />
                    </asp:ButtonField>--%>
                </Columns>
                <PagerStyle CssClass="pagination pagination-sm float-right" />
            </asp:GridView>
        </div>
        <!-- /.card-body -->
    </div>
</asp:Content>
