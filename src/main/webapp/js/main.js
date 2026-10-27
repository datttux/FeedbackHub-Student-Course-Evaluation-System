/**
 * Student Feedback System - Interactive JavaScript
 */

document.addEventListener('DOMContentLoaded', () => {

    // 1. Star Rating Interactive Label
    const ratingInputs = document.querySelectorAll('.star-rating input');
    const ratingLabel = document.getElementById('ratingLabel');

    const ratingDescriptions = {
        '5': '5 Stars - Outstanding / Excellent',
        '4': '4 Stars - Very Good / Exceeded Expectations',
        '3': '3 Stars - Satisfactory / Average',
        '2': '2 Stars - Needs Improvement',
        '1': '1 Star - Unsatisfactory'
    };

    if (ratingInputs.length > 0 && ratingLabel) {
        ratingInputs.forEach(input => {
            input.addEventListener('change', (e) => {
                const val = e.target.value;
                ratingLabel.textContent = ratingDescriptions[val] || (val + ' Stars');
            });
            // Initial check
            if (input.checked) {
                ratingLabel.textContent = ratingDescriptions[input.value] || (input.value + ' Stars');
            }
        });
    }

    // 2. Character Counter for Feedback Textarea
    const commentsArea = document.getElementById('comments');
    const charCount = document.getElementById('charCount');
    if (commentsArea && charCount) {
        const updateCount = () => {
            charCount.textContent = commentsArea.value.length;
        };
        commentsArea.addEventListener('input', updateCount);
        updateCount();
    }

    // 3. Quick-fill credentials for demo
    window.fillStudentDemo = function(rollNo, password) {
        const rollInput = document.getElementById('rollNo');
        const passInput = document.getElementById('password');
        if (rollInput && passInput) {
            rollInput.value = rollNo || 'CS202601';
            passInput.value = password || 'student123';
            showToast('Loaded demo student credentials (CS202601 / student123)');
        }
    };

    window.fillAdminDemo = function(username, password) {
        const userInput = document.getElementById('username');
        const passInput = document.getElementById('password');
        if (userInput && passInput) {
            userInput.value = username || 'admin';
            passInput.value = password || 'admin123';
            showToast('Loaded demo admin credentials (admin / admin123)');
        }
    };

    // 4. Client-side Live Table Filter
    const liveSearch = document.getElementById('liveTableSearch');
    if (liveSearch) {
        liveSearch.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase().trim();
            const rows = document.querySelectorAll('.data-table tbody tr');

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                if (text.includes(query)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    }

    // 5. Toast Notification Helper
    function showToast(message) {
        let toast = document.getElementById('dynamicToast');
        if (!toast) {
            toast = document.createElement('div');
            toast.id = 'dynamicToast';
            toast.style.position = 'fixed';
            toast.style.bottom = '24px';
            toast.style.right = '24px';
            toast.style.background = '#1e293b';
            toast.style.color = '#f8fafc';
            toast.style.border = '1px solid #6366f1';
            toast.style.padding = '12px 20px';
            toast.style.borderRadius = '8px';
            toast.style.boxShadow = '0 10px 25px rgba(0,0,0,0.5)';
            toast.style.zIndex = '9999';
            toast.style.fontWeight = '500';
            toast.style.fontSize = '0.9rem';
            toast.style.transition = 'opacity 0.3s ease';
            document.body.appendChild(toast);
        }
        toast.textContent = message;
        toast.style.opacity = '1';
        setTimeout(() => {
            toast.style.opacity = '0';
        }, 3000);
    }
});
