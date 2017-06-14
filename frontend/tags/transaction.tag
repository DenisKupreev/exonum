<transaction>
    <div class="panel-heading">
        <button class="btn btn-default pull-right page-nav" if={ !transaction } onclick={ refresh }>
            <i class="glyphicon glyphicon-refresh"></i>
            <span class="hidden-xs">Refresh</span>
        </button>
        <button class="btn btn-default pull-left page-nav" if={ transaction } onclick={ back }>
            <i class="glyphicon glyphicon-arrow-left"></i>
            <span class="hidden-xs">Back</span>
        </button>
        <div class="panel-title page-title text-center">
            <div class="h4" if={ transaction }>{ title } transaction</div>
            <div class="h4" if={ !transaction }>Transaction not found</div>
        </div>
    </div>
    <div class="panel-body">
        <virtual if={ transaction && transaction.content }>
            <virtual if={ transaction.content.message_id === 128 }>
                <div class="custom-table text-center">
                    <div class="row">
                        <div class="col-xs-6 custom-table-header-column">From</div>
                        <div class="col-xs-6 custom-table-header-column">To</div>
                    </div>
                    <div class="row">
                        <div class="col-xs-6 custom-table-column">
                            <truncate class="truncate" val={ transaction.content.body.from }></truncate>
                        </div>
                        <div class="col-xs-6 custom-table-column">
                            <truncate class="truncate" val={ transaction.content.body.to }></truncate>
                        </div>
                    </div>
                </div>

                <div class="text-center">
                    <h2>{ numeral(transaction.content.body.amount).format('$0,0.00') }</h2>
                </div>
            </virtual>

            <virtual if={ transaction.content.message_id === 129 }>
                <div class="custom-table text-center">
                    <div class="row">
                        <div class="col-sm-12 custom-table-header-column">To</div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12 custom-table-column">
                            <truncate class="truncate" val={ transaction.content.body.wallet }></truncate>
                        </div>
                    </div>
                </div>

                <div class="text-center">
                    <h2>{ numeral(transaction.content.body.amount).format('$0,0.00') }</h2>
                </div>
            </virtual>

            <virtual if={ transaction.content.message_id === 130 }>
                <div class="custom-table text-center">
                    <div class="row">
                        <div class="col-sm-12 custom-table-header-column">Name</div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12 custom-table-column">
                            { transaction.content.body.name }
                        </div>
                    </div>
                </div>
            </virtual>
        </virtual>

        <p if={ !transaction } class="text-muted text-center">
            <i class="glyphicon glyphicon-ban-circle"></i> The server is not know the requested transaction. <br>Wait a few seconds and reload the page.
        </p>
    </div>

    <script>
        var self = this;

        this.toggleLoading(true);
        this.service.getTransaction(this.opts.hash, function(response) {
            if (response.content) {
                switch(response.content.message_id) {
                    case 128:
                        self.title = 'Transfer';
                        break;
                    case 129:
                        self.title = 'Add Funds';
                        break;
                    case 130:
                        self.title = 'Create Wallet';
                        break;
                }
                self.transaction = response;
                self.update();
            }

            self.toggleLoading(false);
        });

        back(e) {
            e.preventDefault();
            route('/blockchain/block/' + self.transaction.location.block_height);
        }

        refresh(e) {
            e.preventDefault();
            window.location.reload();
        }
    </script>
</transaction>