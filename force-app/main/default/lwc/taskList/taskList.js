import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTasks from '@salesforce/apex/TaskController.getTasks';
import updateTaskStatus from '@salesforce/apex/TaskController.updateTaskStatus';
import deleteTask from '@salesforce/apex/TaskController.deleteTask';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Due Date', fieldName: 'Due_Date__c', type: 'date' },
    { label: 'Status', fieldName: 'Completed__c', type: 'boolean' },
    {
        type: 'action',
        typeAttributes: {
            rowActions: [
                { label: 'Edit', name: 'edit' },
                { label: 'Complete', name: 'complete' },
                { label: 'Delete', name: 'delete' }
            ]
        }
    }
];

export default class TaskList extends LightningElement {
    @track tasks;
    @track showForm = false;
    @track selectedTaskId;
    columns = COLUMNS;
    wiredTasksResult;

    @wire(getTasks)
    wiredTasks(result) {
        this.wiredTasksResult = result;
        if (result.data) {
            this.tasks = result.data;
        }
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;

        switch (action.name) {
            case 'edit':
                this.selectedTaskId = row.Id;
                this.showForm = true;
                break;
            case 'complete':
                this.handleComplete(row.Id);
                break;
            case 'delete':
                this.handleDelete(row.Id);
                break;
            default:
                break;
        }
    }

    async handleDelete(taskId) {
        try {
            await deleteTask({ taskId: taskId });
            await refreshApex(this.wiredTasksResult);
            this.showToast('Success', 'Task deleted successfully', 'success');
        } catch (error) {
            console.error('Delete error:', error);
        }
    }

    async handleComplete(taskId) {
        try {
            await updateTaskStatus({ taskId: taskId, completed: true });
            await refreshApex(this.wiredTasksResult);
            this.showToast('Success', 'Task marked as completed', 'success');
        } catch (error) {
            console.error('Complete error:', error);
        }
    }

    handleNewTask() {
        this.selectedTaskId = null;
        this.showForm = true;
    }

    handleTaskUpdated() {
        refreshApex(this.wiredTasksResult);
        this.showForm = false;
    }

    handleCancel() {
        this.showForm = false;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}