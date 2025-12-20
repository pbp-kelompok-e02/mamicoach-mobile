This file is a merged representation of a subset of the codebase, containing files not matching ignore patterns, combined into a single document by Repomix.
The content has been processed where comments have been removed, empty lines have been removed, content has been compressed (code blocks are separated by ⋮---- delimiter), security check has been disabled.

# File Summary

## Purpose
This file contains a packed representation of a subset of the repository's contents that is considered the most important context.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.

## File Format
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  a. A header with the file path (## File: path/to/file)
  b. The full contents of the file in a code block

## Usage Guidelines
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.

## Notes
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Files matching these patterns are excluded: assets/erd.svg, dataset/*, *.sh, **/tests.py, *.bat
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Code comments have been removed from supported file types
- Empty lines have been removed from all files
- Content has been compressed - code blocks are separated by ⋮---- delimiter
- Security check has been disabled - content may contain sensitive information
- Files are sorted by Git change count (files with more changes are at the bottom)

# Directory Structure
```
.github/
  workflows/
    bandit.yml
    build.yml
    deploy-to-pws.yml
admin_panel/
  management/
    commands/
      create_admin.py
  migrations/
    0001_initial.py
  templates/
    admin_panel/
      base.html
      booking_delete_confirm.html
      bookings.html
      change_password.html
      coach_delete_confirm.html
      coach_verification_detail.html
      coaches.html
      course_delete_confirm.html
      courses.html
      dashboard.html
      login.html
      logs.html
      payments.html
      settings.html
      user_delete_confirm.html
      users.html
  admin.py
  apps.py
  models.py
  urls.py
  views.py
booking/
  migrations/
    0001_initial.py
  services/
    __init__.py
    availability.py
  templates/
    booking/
      booking_card.html
      confirmation.html
      success.html
  admin.py
  apps.py
  forms.py
  models.py
  urls.py
  views.py
chat/
  migrations/
    0001_initial.py
  templates/
    pages/
      chat_interface.html
  admin.py
  apps.py
  models.py
  urls.py
  views.py
courses_and_coach/
  management/
    commands/
      __init__.py
      populate_all.py
      seed_categories.py
    __init__.py
  migrations/
    0001_initial.py
  templates/
    courses_and_coach/
      coaches/
        coach_details.html
      courses/
        confirm_delete.html
        courses_details.html
        courses_list.html
        create_course.html
        edit_course.html
        my_courses.html
      partials/
        coach_card.html
        course_card.html
      category_detail.html
      coaches_list.html
      courses_list.html
  admin.py
  apps.py
  forms.py
  models.py
  urls.py
  views.py
main/
  management/
    commands/
      crawl_superprof.py
  templates/
    pages/
      landing_page/
        categories.html
        coach_section.html
        featured.html
        hero.html
        index.html
        testimonials.html
        top_coaches.html
      main.html
    partials/
      _footer.html
      _navbar.html
    404.html
    500.html
    base_chat.html
    base.html
  admin.py
  apps.py
  urls.py
  views.py
mami_coach/
  asgi.py
  settings.py
  urls.py
  wsgi.py
payment/
  migrations/
    0001_initial.py
  templates/
    payment/
      callback.html
      method_selection.html
  admin.py
  apps.py
  midtrans_service.py
  models.py
  urls.py
  views.py
reviews/
  migrations/
    0001_initial.py
  templates/
    pages/
      create_review.html
      edit_review.html
      sample_review.html
    partials/
      _review_card_styled.html
      _review_card.html
      _review_form.html
  admin.py
  apps.py
  forms.py
  models.py
  urls.py
  views.py
schedule/
  migrations/
    0001_initial.py
  templates/
    schedule/
      _availability_modal.html
  admin.py
  apps.py
  models.py
  urls.py
  views.py
static/
  css/
    global.css
    payment.css
  js/
    payment-callback.js
    payment-method.js
    schedule-availability.js
    toast.js
user_profile/
  migrations/
    0001_initial.py
  templates/
    coach_profile.html
    dashboard_coach.html
    dashboard_user.html
    login.html
    register_coach.html
    register.html
    user_profile.html
  admin.py
  apps.py
  forms.py
  models.py
  urls.py
  views.py
.env.example
.gitignore
manage.py
README.md
requirements.txt
sonar-project.properties
```

# Files

## File: .github/workflows/bandit.yml
````yaml
name: Bandit
on: push
jobs:
  analyze:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      actions: read
      contents: read
    steps:
      - name: Perform Bandit Analysis
        uses: PyCQA/bandit-action@v1
````

## File: .github/workflows/build.yml
````yaml
name: Build
on:
  push
jobs:
  build:
    name: Build and analyze
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: SonarSource/sonarqube-scan-action@v6
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
      - uses: SonarSource/sonarqube-quality-gate-action@v1
        timeout-minutes: 5
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
````

## File: .github/workflows/deploy-to-pws.yml
````yaml
name: Push to PWS
on:
  push:
    branches: [ master ]
jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v2
      with:
        fetch-depth: 0
    - name: Set up Git
      run: |
        git config --global user.name 'github-actions[bot]'
        git config --global user.email 'github-actions[bot]@users.noreply.github.com'
    - name: Push to PWS
      env:
        PWS_URL: ${{ secrets.PWS_URL }}
      run: |
          current_branch=$(git branch --show-current)
          echo "Current branch: $current_branch"
          push_output=$(git push $PWS_URL $current_branch:master 2>&1)
          if [[ $? -ne 0 ]]; then
            echo "Push failed with output: $push_output"
            echo "Error: Unable to push changes. Please check the error message above and resolve any conflicts manually."
            exit 1
          fi
          echo "Push successful with output: $push_output"
````

## File: admin_panel/management/commands/create_admin.py
````python
class Command(BaseCommand)
⋮----
help = 'Create default admin user for admin panel'
def add_arguments(self, parser)
def handle(self, *args, **options)
⋮----
username = options['username']
password = options['password']
email = options['email']
⋮----
admin = AdminUser(username=username, email=email)
````

## File: admin_panel/migrations/0001_initial.py
````python
class Migration(migrations.Migration)
⋮----
initial = True
dependencies = [
operations = [
````

## File: admin_panel/templates/admin_panel/base.html
````html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}MamiCoach Admin Panel{% endblock %}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-100">
    <div class="flex h-screen overflow-hidden">
        <aside class="w-64 bg-gray-900 text-white flex-shrink-0">
            <div class="p-6">
                <h1 class="text-2xl font-bold text-green-400">MamiCoach</h1>
                <p class="text-sm text-gray-400">Admin Panel</p>
            </div>
            <nav class="mt-6">
                <a href="{% url 'admin_panel:dashboard' %}" class="flex items-center px-6 py-3 text-gray-300 hover:bg-gray-800 hover:text-white transition-colors {% if request.resolver_match.url_name == 'dashboard' %}bg-gray-800 text-white border-l-4 border-green-500{% endif %}">
                    <i class="fas fa-tachometer-alt w-5"></i>
                    <span class="ml-3">Dashboard</span>
                </a>
                <div class="mt-6">
                    <p class="px-6 text-xs font-semibold text-gray-500 uppercase tracking-wider">Management</p>
                    <a href="{% url 'admin_panel:users' %}" class="flex items-center px-6 py-3 text-gray-300 hover:bg-gray-800 hover:text-white transition-colors {% if request.resolver_match.url_name == 'users' %}bg-gray-800 text-white border-l-4 border-green-500{% endif %}">
                        <i class="fas fa-users w-5"></i>
                        <span class="ml-3">Users</span>
                    </a>
                    <a href="{% url 'admin_panel:coaches' %}" class="flex items-center px-6 py-3 text-gray-300 hover:bg-gray-800 hover:text-white transition-colors {% if request.resolver_match.url_name == 'coaches' %}bg-gray-800 text-white border-l-4 border-green-500{% endif %}">
                        <i class="fas fa-chalkboard-teacher w-5"></i>
                        <span class="ml-3">Coaches</span>
                    </a>
                    <a href="{% url 'admin_panel:courses' %}" class="flex items-center px-6 py-3 text-gray-300 hover:bg-gray-800 hover:text-white transition-colors {% if request.resolver_match.url_name == 'courses' %}bg-gray-800 text-white border-l-4 border-green-500{% endif %}">
                        <i class="fas fa-book w-5"></i>
                        <span class="ml-3">Courses</span>
                    </a>
                    <a href="{% url 'admin_panel:bookings' %}" class="flex items-center px-6 py-3 text-gray-300 hover:bg-gray-800 hover:text-white transition-colors {% if request.resolver_match.url_name == 'bookings' %}bg-gray-800 text-white border-l-4 border-green-500{% endif %}">
                        <i class="fas fa-calendar-check w-5"></i>
                        <span class="ml-3">Bookings</span>
                    </a>
                    <a href="{% url 'admin_panel:payments' %}" class="flex items-center px-6 py-3 text-gray-300 hover:bg-gray-800 hover:text-white transition-colors {% if request.resolver_match.url_name == 'payments' %}bg-gray-800 text-white border-l-4 border-green-500{% endif %}">
                        <i class="fas fa-credit-card w-5"></i>
                        <span class="ml-3">Payments</span>
                    </a>
                </div>
                <div class="mt-6">
                    <p class="px-6 text-xs font-semibold text-gray-500 uppercase tracking-wider">System</p>
                    <a href="{% url 'admin_panel:settings' %}" class="flex items-center px-6 py-3 text-gray-300 hover:bg-gray-800 hover:text-white transition-colors {% if request.resolver_match.url_name == 'settings' %}bg-gray-800 text-white border-l-4 border-green-500{% endif %}">
                        <i class="fas fa-cog w-5"></i>
                        <span class="ml-3">Settings</span>
                    </a>
                    <a href="{% url 'admin_panel:logs' %}" class="flex items-center px-6 py-3 text-gray-300 hover:bg-gray-800 hover:text-white transition-colors {% if request.resolver_match.url_name == 'logs' %}bg-gray-800 text-white border-l-4 border-green-500{% endif %}">
                        <i class="fas fa-list w-5"></i>
                        <span class="ml-3">Activity Logs</span>
                    </a>
                </div>
                <div class="mt-6">
                    <p class="px-6 text-xs font-semibold text-gray-500 uppercase tracking-wider">Account</p>
                    <a href="{% url 'admin_panel:change_password' %}" class="flex items-center px-6 py-3 text-gray-300 hover:bg-gray-800 hover:text-white transition-colors {% if request.resolver_match.url_name == 'change_password' %}bg-gray-800 text-white border-l-4 border-green-500{% endif %}">
                        <i class="fas fa-key w-5"></i>
                        <span class="ml-3">Change Password</span>
                    </a>
                    <a href="{% url 'admin_panel:logout' %}" class="flex items-center px-6 py-3 text-red-400 hover:bg-gray-800 hover:text-red-300 transition-colors">
                        <i class="fas fa-sign-out-alt w-5"></i>
                        <span class="ml-3">Logout</span>
                    </a>
                </div>
            </nav>
        </aside>
        <div class="flex-1 flex flex-col overflow-hidden">
            <header class="bg-white shadow-sm z-10">
                <div class="flex items-center justify-between px-6 py-4">
                    <h2 class="text-2xl font-semibold text-gray-800">{% block page_title %}Dashboard{% endblock %}</h2>
                    <div class="flex items-center space-x-4">
                        <span class="text-gray-600">Welcome, <strong>{{ user.username }}</strong></span>
                        <div class="w-10 h-10 rounded-full bg-green-500 flex items-center justify-center text-white font-bold">
                            {{ user.username|slice:":1"|upper }}
                        </div>
                    </div>
                </div>
            </header>
            <main class="flex-1 overflow-y-auto bg-gray-100 p-6">
                {% if messages %}
                    {% for message in messages %}
                    <div class="mb-4 p-4 rounded-lg {% if message.tags == 'success' %}bg-green-100 border-green-500 text-green-800{% elif message.tags == 'error' %}bg-red-100 border-red-500 text-red-800{% else %}bg-blue-100 border-blue-500 text-blue-800{% endif %} border-l-4">
                        {{ message }}
                    </div>
                    {% endfor %}
                {% endif %}
                {% block content %}
                {% endblock %}
            </main>
        </div>
    </div>
</body>
</html>
````

## File: admin_panel/templates/admin_panel/booking_delete_confirm.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Delete Booking{% endblock %}
{% block content %}
<div class="max-w-2xl mx-auto">
    <div class="bg-white rounded-lg shadow-md">
        <div class="p-6 border-b border-gray-200 bg-red-50">
            <h3 class="text-xl font-semibold text-red-900 flex items-center">
                <i class="fas fa-exclamation-triangle mr-2"></i>
                Confirm Booking Deletion
            </h3>
        </div>
        <div class="p-6">
            <p class="text-gray-700 mb-4">
                Are you sure you want to delete this booking? This action cannot be undone.
            </p>
            <div class="bg-gray-50 p-4 rounded-lg mb-6">
                <h4 class="font-semibold text-lg mb-3">Booking #{{ booking.id }}</h4>
                <div class="space-y-2 text-sm">
                    <div class="grid grid-cols-2 gap-2">
                        <span class="text-gray-600">User:</span>
                        <span class="font-medium">{{ booking.user.username }}</span>
                    </div>
                    <div class="grid grid-cols-2 gap-2">
                        <span class="text-gray-600">Course:</span>
                        <span class="font-medium">{{ booking.course.name }}</span>
                    </div>
                    <div class="grid grid-cols-2 gap-2">
                        <span class="text-gray-600">Status:</span>
                        <span class="px-2 py-1 rounded-full text-xs font-medium inline-block
                            {% if booking.status == 'pending' %}bg-orange-100 text-orange-700
                            {% elif booking.status == 'paid' %}bg-blue-100 text-blue-700
                            {% elif booking.status == 'confirmed' %}bg-green-100 text-green-700
                            {% elif booking.status == 'done' %}bg-purple-100 text-purple-700
                            {% elif booking.status == 'canceled' %}bg-red-100 text-red-700
                            {% else %}bg-gray-100 text-gray-700{% endif %}">
                            {{ booking.status }}
                        </span>
                    </div>
                    <div class="grid grid-cols-2 gap-2">
                        <span class="text-gray-600">Created:</span>
                        <span class="font-medium">{{ booking.created_at|date:"Y-m-d H:i" }}</span>
                    </div>
                </div>
            </div>
            <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-6">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-exclamation-triangle text-yellow-400"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm text-yellow-700">
                            <strong>Warning:</strong> Deleting this booking will also delete associated payment records.
                        </p>
                    </div>
                </div>
            </div>
            <form method="POST" class="flex justify-end space-x-3">
                {% csrf_token %}
                <a href="{% url 'admin_panel:bookings' %}" class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors">
                    Cancel
                </a>
                <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
                    <i class="fas fa-trash mr-2"></i>
                    Delete Booking
                </button>
            </form>
        </div>
    </div>
</div>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/bookings.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Booking Management{% endblock %}
{% block content %}
<div class="bg-white rounded-lg shadow-md">
    <div class="p-6 border-b border-gray-200">
        <h3 class="text-xl font-semibold text-gray-900">All Bookings</h3>
        <p class="text-sm text-gray-600 mt-1">Manage booking appointments and statuses</p>
    </div>
    <div class="p-6">
        <div class="mb-6 bg-gray-50 rounded-lg p-4">
            <form method="GET" class="flex gap-2 flex-wrap items-end">
                <div class="flex-1 min-w-64">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Search</label>
                    <input type="text"
                           name="search"
                           value="{{ search_query }}"
                           placeholder="Search by Username, Email, Course, or Booking ID..."
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Per Page</label>
                    <select name="per_page" class="px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="10" {% if per_page == 10 %}selected{% endif %}>10</option>
                        <option value="25" {% if per_page == 25 %}selected{% endif %}>25</option>
                        <option value="50" {% if per_page == 50 %}selected{% endif %}>50</option>
                    </select>
                </div>
                <input type="hidden" name="status" value="{{ status }}">
                <input type="hidden" name="page" value="1">
                <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium">
                    Search
                </button>
                <a href="?status=all" class="px-4 py-2 bg-gray-400 text-white rounded-lg hover:bg-gray-500 font-medium">
                    Reset
                </a>
            </form>
        </div>
        <div class="mb-4 flex gap-2 flex-wrap">
            <a href="?status=all" class="px-4 py-2 rounded-lg text-sm font-medium {% if not status or status == 'all' %}bg-gray-900 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                All
            </a>
            <a href="?status=pending" class="px-4 py-2 rounded-lg text-sm font-medium {% if status == 'pending' %}bg-orange-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Pending
            </a>
            <a href="?status=paid" class="px-4 py-2 rounded-lg text-sm font-medium {% if status == 'paid' %}bg-blue-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Paid
            </a>
            <a href="?status=confirmed" class="px-4 py-2 rounded-lg text-sm font-medium {% if status == 'confirmed' %}bg-green-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Confirmed
            </a>
            <a href="?status=done" class="px-4 py-2 rounded-lg text-sm font-medium {% if status == 'done' %}bg-purple-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Done
            </a>
            <a href="?status=cancelled" class="px-4 py-2 rounded-lg text-sm font-medium {% if status == 'cancelled' %}bg-red-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Cancelled
            </a>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                    <tr class="text-left text-xs font-semibold text-gray-600 uppercase border-b-2 border-gray-200">
                        <th class="pb-3 pr-4">ID</th>
                        <th class="pb-3 pr-4">User</th>
                        <th class="pb-3 pr-4">Course</th>
                        <th class="pb-3 pr-4">Schedule</th>
                        <th class="pb-3 pr-4">Amount</th>
                        <th class="pb-3 pr-4">Status</th>
                        <th class="pb-3 pr-4">Created</th>
                        <th class="pb-3">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {% for booking in bookings %}
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="py-4 pr-4">#{{ booking.id }}</td>
                        <td class="py-4 pr-4">{{ booking.user.username }}</td>
                        <td class="py-4 pr-4">{{ booking.course.title|truncatewords:4 }}</td>
                        <td class="py-4 pr-4 text-sm">
                            {{ booking.start_datetime|date:"Y-m-d H:i" }}
                        </td>
                        <td class="py-4 pr-4 font-semibold">Rp {{ booking.course.price|floatformat:0 }}</td>
                        <td class="py-4 pr-4">
                            <span class="px-2 py-1 rounded-full text-xs font-medium
                                {% if booking.status == 'pending' %}bg-orange-100 text-orange-700
                                {% elif booking.status == 'paid' %}bg-blue-100 text-blue-700
                                {% elif booking.status == 'confirmed' %}bg-green-100 text-green-700
                                {% elif booking.status == 'done' %}bg-purple-100 text-purple-700
                                {% elif booking.status == 'cancelled' %}bg-red-100 text-red-700
                                {% else %}bg-gray-100 text-gray-700{% endif %}">
                                {{ booking.status }}
                            </span>
                        </td>
                        <td class="py-4 pr-4 text-sm text-gray-600">{{ booking.created_at|date:"Y-m-d H:i" }}</td>
                        <td class="py-4">
                            <div class="flex space-x-2">
                                <form method="POST" action="{% url 'admin_panel:booking_update_status' booking.id %}" class="inline">
                                    {% csrf_token %}
                                    <select name="status" onchange="this.form.submit()" class="text-xs border border-gray-300 rounded px-2 py-1">
                                        <option value="">Change Status</option>
                                        <option value="pending" {% if booking.status == 'pending' %}selected{% endif %}>Pending</option>
                                        <option value="paid" {% if booking.status == 'paid' %}selected{% endif %}>Paid</option>
                                        <option value="confirmed" {% if booking.status == 'confirmed' %}selected{% endif %}>Confirmed</option>
                                        <option value="done" {% if booking.status == 'done' %}selected{% endif %}>Done</option>
                                        <option value="canceled" {% if booking.status == 'canceled' %}selected{% endif %}>Canceled</option>
                                    </select>
                                </form>
                                <a href="{% url 'admin_panel:booking_delete' booking.id %}" class="text-red-600 hover:text-red-800 text-sm" title="Delete">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    {% empty %}
                    <tr>
                        <td colspan="8" class="py-8 text-center text-gray-500">No bookings found</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
        {% if paginator.num_pages > 1 %}
        <div class="mt-6 flex items-center justify-between">
            <div class="text-sm text-gray-600">
                Showing page <strong>{{ bookings.number }}</strong> of <strong>{{ paginator.num_pages }}</strong>
                ({{ paginator.count }} total bookings)
            </div>
            <nav class="flex gap-2">
                {% if bookings.has_previous %}
                <a href="?page=1&status={{ status }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    First
                </a>
                <a href="?page={{ bookings.previous_page_number }}&status={{ status }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Previous
                </a>
                {% endif %}
                {% with pages=paginator.page_range %}
                {% if pages|length > 1 %}
                <div class="flex gap-1">
                    {% for page_num in pages %}
                        {% if page_num == bookings.number %}
                        <span class="px-3 py-2 rounded bg-blue-600 text-white font-medium">
                            {{ page_num }}
                        </span>
                        {% elif page_num == '...' %}
                        <span class="px-3 py-2 text-gray-600">...</span>
                        {% else %}
                        <a href="?page={{ page_num }}&status={{ status }}&search={{ search_query }}&per_page={{ per_page }}"
                           class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                            {{ page_num }}
                        </a>
                        {% endif %}
                    {% endfor %}
                </div>
                {% endif %}
                {% endwith %}
                {% if bookings.has_next %}
                <a href="?page={{ bookings.next_page_number }}&status={{ status }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Next
                </a>
                <a href="?page={{ paginator.num_pages }}&status={{ status }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Last
                </a>
                {% endif %}
            </nav>
        </div>
        {% endif %}
    </div>
</div>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/change_password.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Change Password{% endblock %}
{% block content %}
<div class="max-w-2xl mx-auto">
    <div class="bg-white rounded-lg shadow-md p-8">
        <h3 class="text-2xl font-semibold text-gray-900 mb-6">Change Your Password</h3>
        <form method="post" class="space-y-6">
            {% csrf_token %}
            <div>
                <label for="old_password" class="block text-sm font-medium text-gray-700 mb-2">
                    Current Password
                </label>
                <input
                    type="password"
                    id="old_password"
                    name="old_password"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                    placeholder="Enter your current password"
                >
            </div>
            <div>
                <label for="new_password1" class="block text-sm font-medium text-gray-700 mb-2">
                    New Password
                </label>
                <input
                    type="password"
                    id="new_password1"
                    name="new_password1"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                    placeholder="Enter your new password"
                >
                <p class="mt-2 text-sm text-gray-600">
                    Password must be at least 8 characters long and contain a mix of letters and numbers.
                </p>
            </div>
            <div>
                <label for="new_password2" class="block text-sm font-medium text-gray-700 mb-2">
                    Confirm New Password
                </label>
                <input
                    type="password"
                    id="new_password2"
                    name="new_password2"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                    placeholder="Confirm your new password"
                >
            </div>
            <div class="flex gap-4 pt-4">
                <button
                    type="submit"
                    class="flex-1 bg-green-500 hover:bg-green-600 text-white font-semibold py-3 rounded-lg transition duration-200 shadow-md hover:shadow-lg"
                >
                    Change Password
                </button>
                <a
                    href="{% url 'admin_panel:dashboard' %}"
                    class="flex-1 bg-gray-200 hover:bg-gray-300 text-gray-800 font-semibold py-3 rounded-lg transition duration-200 text-center"
                >
                    Cancel
                </a>
            </div>
        </form>
        <div class="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
            <h4 class="text-sm font-semibold text-blue-900 mb-2">Password Requirements:</h4>
            <ul class="text-sm text-blue-800 space-y-1">
                <li>• At least 8 characters long</li>
                <li>• Mix of uppercase and lowercase letters</li>
                <li>• At least one number</li>
                <li>• Cannot be too similar to your username</li>
                <li>• Cannot be a commonly used password</li>
            </ul>
        </div>
    </div>
</div>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/coach_delete_confirm.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Delete Coach{% endblock %}
{% block content %}
<div class="max-w-2xl mx-auto">
    <div class="bg-white rounded-lg shadow-md">
        <div class="p-6 border-b border-gray-200 bg-red-50">
            <h3 class="text-xl font-semibold text-red-900 flex items-center">
                <i class="fas fa-exclamation-triangle mr-2"></i>
                Confirm Coach Deletion
            </h3>
        </div>
        <div class="p-6">
            <p class="text-gray-700 mb-4">
                Are you sure you want to delete this coach? This action cannot be undone.
            </p>
            <div class="bg-gray-50 p-4 rounded-lg mb-6">
                <div class="flex items-center mb-4">
                    <img src="{{ coach.image_url }}" alt="{{ coach.user.username }}" class="w-16 h-16 rounded-full mr-4 object-cover">
                    <div>
                        <h4 class="font-semibold text-lg">{{ coach.user.get_full_name|default:coach.user.username }}</h4>
                        <p class="text-sm text-gray-600">@{{ coach.user.username }}</p>
                        <p class="text-sm text-gray-600">{{ coach.user.email }}</p>
                    </div>
                </div>
                <div class="grid grid-cols-2 gap-4 text-sm">
                    <div>
                        <span class="text-gray-600">Rating:</span>
                        <span class="font-medium">{{ coach.rating|floatformat:1 }} ({{ coach.rating_count }} reviews)</span>
                    </div>
                    <div>
                        <span class="text-gray-600">Hours Coached:</span>
                        <span class="font-medium">{{ coach.total_hours_coached_formatted }}</span>
                    </div>
                    <div>
                        <span class="text-gray-600">Verified:</span>
                        <span class="font-medium">{{ coach.verified|yesno:"Yes,No" }}</span>
                    </div>
                </div>
            </div>
            <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-6">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-exclamation-triangle text-yellow-400"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm text-yellow-700">
                            <strong>Warning:</strong> Deleting this coach will also delete:
                        </p>
                        <ul class="list-disc list-inside text-sm text-yellow-700 mt-2">
                            <li>The associated user account</li>
                            <li>All courses created by this coach</li>
                            <li>All related bookings and payments</li>
                        </ul>
                    </div>
                </div>
            </div>
            <form method="POST" class="flex justify-end space-x-3">
                {% csrf_token %}
                <a href="{% url 'admin_panel:coaches' %}" class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors">
                    Cancel
                </a>
                <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
                    <i class="fas fa-trash mr-2"></i>
                    Delete Coach
                </button>
            </form>
        </div>
    </div>
</div>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/coach_verification_detail.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Coach Verification Details{% endblock %}
{% block content %}
<div class="max-w-4xl mx-auto">
    <div class="bg-white rounded-lg shadow-md mb-6">
        <div class="p-6 border-b border-gray-200">
            <h3 class="text-xl font-semibold text-gray-900">Coach Information</h3>
        </div>
        <div class="p-6">
            <div class="flex items-start space-x-6">
                <img src="{{ coach.image_url }}" alt="{{ coach.user.username }}" class="w-24 h-24 rounded-full object-cover">
                <div class="flex-1">
                    <h4 class="text-2xl font-bold text-gray-900">{{ coach.user.get_full_name|default:coach.user.username }}</h4>
                    <p class="text-gray-600">@{{ coach.user.username }}</p>
                    <p class="text-gray-600 mt-1">{{ coach.user.email }}</p>
                    <div class="grid grid-cols-3 gap-4 mt-4">
                        <div>
                            <span class="text-sm text-gray-600">Rating:</span>
                            <div class="font-semibold">
                                <span class="text-yellow-500"><i class="fas fa-star"></i> {{ coach.rating|floatformat:1 }}</span>
                                <span class="text-gray-500 text-sm">({{ coach.rating_count }})</span>
                            </div>
                        </div>
                        <div>
                            <span class="text-sm text-gray-600">Hours Coached:</span>
                            <div class="font-semibold">{{ coach.total_hours_coached_formatted }}</div>
                        </div>
                        <div>
                            <span class="text-sm text-gray-600">Verified Badge:</span>
                            <div>
                                {% if coach.verified %}
                                    <span class="px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-700">
                                        <i class="fas fa-certificate"></i> Has Badge
                                    </span>
                                {% else %}
                                    <span class="px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-700">
                                        <i class="fas fa-certificate"></i> No Badge
                                    </span>
                                {% endif %}
                            </div>
                        </div>
                    </div>
                    <div class="mt-4">
                        <span class="text-sm text-gray-600">Approval Status (Can Train):</span>
                        <div class="mt-1">
                            <span class="px-3 py-1 rounded-full text-sm font-medium
                                {% if admin_verification.status == 'approved' %}bg-green-100 text-green-700
                                {% elif admin_verification.status == 'rejected' %}bg-red-100 text-red-700
                                {% else %}bg-yellow-100 text-yellow-700{% endif %}">
                                {% if admin_verification.status == 'approved' %}
                                    <i class="fas fa-check-circle"></i> Approved - Can Train on Platform
                                {% elif admin_verification.status == 'rejected' %}
                                    <i class="fas fa-ban"></i> Rejected - Cannot Train on Platform
                                {% else %}
                                    <i class="fas fa-clock"></i> Pending Review
                                {% endif %}
                            </span>
                        </div>
                    </div>
                    <div class="mt-4">
                        <span class="text-sm text-gray-600">Bio:</span>
                        <p class="text-gray-800 mt-1">{{ coach.bio }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="bg-white rounded-lg shadow-md">
        <div class="p-6 border-b border-gray-200">
            <h3 class="text-xl font-semibold text-gray-900">Coach Approval Management</h3>
            <p class="text-sm text-gray-600 mt-1">Approve = Give verified badge + approval status | Reject = Remove badge + reject status</p>
        </div>
        <div class="p-6">
            <div class="mb-6">
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <span class="text-sm text-gray-600">Platform Approval Status:</span>
                        <div class="mt-1">
                            <span class="px-3 py-1 rounded-full text-sm font-medium
                                {% if admin_verification.status == 'approved' %}bg-green-100 text-green-700
                                {% elif admin_verification.status == 'rejected' %}bg-red-100 text-red-700
                                {% else %}bg-yellow-100 text-yellow-700{% endif %}">
                                {% if admin_verification.status == 'approved' %}
                                    <i class="fas fa-check-circle"></i> Can Train on Platform
                                {% elif admin_verification.status == 'rejected' %}
                                    <i class="fas fa-ban"></i> Cannot Train on Platform
                                {% else %}
                                    <i class="fas fa-clock"></i> Pending Review
                                {% endif %}
                            </span>
                        </div>
                    </div>
                    <div>
                        <span class="text-sm text-gray-600">Status Updated:</span>
                        <div class="font-medium mt-1">{{ admin_verification.created_at|date:"Y-m-d H:i" }}</div>
                    </div>
                </div>
                {% if admin_verification.certificate_url %}
                <div class="mt-4">
                    <span class="text-sm text-gray-600">Certificate URL:</span>
                    <div class="mt-1">
                        <a href="{{ admin_verification.certificate_url }}" target="_blank" class="text-blue-600 hover:text-blue-800">
                            {{ admin_verification.certificate_url }}
                        </a>
                    </div>
                </div>
                {% endif %}
                {% if admin_verification.notes %}
                <div class="mt-4">
                    <span class="text-sm text-gray-600">Notes:</span>
                    <div class="mt-1 p-3 bg-gray-50 rounded border border-gray-200">
                        {{ admin_verification.notes }}
                    </div>
                </div>
                {% endif %}
            </div>
            <div class="border-t border-gray-200 pt-6">
                <h4 class="font-semibold text-gray-900 mb-4">Update Approval Status</h4>
                <form method="POST" class="space-y-4">
                    {% csrf_token %}
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Notes (Optional)</label>
                        <textarea name="notes" rows="3" class="w-full border border-gray-300 rounded-lg p-2 focus:ring-2 focus:ring-green-500 focus:border-transparent" placeholder="Add notes about this approval...">{{ admin_verification.notes }}</textarea>
                    </div>
                    <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-4">
                        <p class="text-sm text-blue-800">
                            <i class="fas fa-info-circle mr-2"></i>
                            <strong>Approve:</strong> Sets status to approved AND gives verified badge<br>
                            <i class="fas fa-info-circle mr-2 invisible"></i>
                            <strong>Reject:</strong> Sets status to rejected AND removes verified badge<br>
                            <i class="fas fa-info-circle mr-2 invisible"></i>
                            <strong>Pending:</strong> Sets status to pending (badge unchanged)
                        </p>
                    </div>
                    <div class="flex space-x-3">
                        <button type="submit" name="action" value="approve" class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
                            <i class="fas fa-check-circle mr-2"></i>
                            Approve (+ Badge)
                        </button>
                        <button type="submit" name="action" value="reject" class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
                            <i class="fas fa-times-circle mr-2"></i>
                            Reject (- Badge)
                        </button>
                        <button type="submit" name="action" value="pending" class="px-6 py-2 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700 transition-colors">
                            <i class="fas fa-clock mr-2"></i>
                            Set to Pending
                        </button>
                        <a href="{% url 'admin_panel:coaches' %}" class="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Back to Coaches
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/coaches.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Coach Management{% endblock %}
{% block content %}
<div class="bg-white rounded-lg shadow-md">
    <div class="p-6 border-b border-gray-200">
        <h3 class="text-xl font-semibold text-gray-900">All Coaches</h3>
        <p class="text-sm text-gray-600 mt-1">Manage coach profiles and specializations</p>
    </div>
    <div class="p-6">
        <div class="mb-6 bg-gray-50 rounded-lg p-4">
            <form method="GET" class="flex gap-2 flex-wrap items-end">
                <div class="flex-1 min-w-64">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Search</label>
                    <input type="text"
                           name="search"
                           value="{{ search_query }}"
                           placeholder="Search by Coach Name, Username, Email..."
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Per Page</label>
                    <select name="per_page" class="px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="10" {% if per_page == 10 %}selected{% endif %}>10</option>
                        <option value="25" {% if per_page == 25 %}selected{% endif %}>25</option>
                        <option value="50" {% if per_page == 50 %}selected{% endif %}>50</option>
                    </select>
                </div>
                <input type="hidden" name="page" value="1">
                <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium">
                    Search
                </button>
                <a href="?" class="px-4 py-2 bg-gray-400 text-white rounded-lg hover:bg-gray-500 font-medium">
                    Reset
                </a>
            </form>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                    <tr class="text-left text-xs font-semibold text-gray-600 uppercase border-b-2 border-gray-200">
                        <th class="pb-3 pr-4">ID</th>
                        <th class="pb-3 pr-4">Coach</th>
                        <th class="pb-3 pr-4">Bio</th>
                        <th class="pb-3 pr-4">Rating</th>
                        <th class="pb-3 pr-4">Hours Coached</th>
                        <th class="pb-3 pr-4">Verified Badge</th>
                        <th class="pb-3 pr-4">Approval Status</th>
                        <th class="pb-3">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {% for coach in coaches %}
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="py-4 pr-4 text-sm">{{ coach.id }}</td>
                        <td class="py-4 pr-4">
                            <div class="flex items-center">
                                <img src="{{ coach.image_url }}" alt="{{ coach.user.username }}" class="w-10 h-10 rounded-full mr-3 object-cover">
                                <div>
                                    <div class="font-medium">{{ coach.user.get_full_name|default:coach.user.username }}</div>
                                    <div class="text-xs text-gray-500">@{{ coach.user.username }}</div>
                                </div>
                            </div>
                        </td>
                        <td class="py-4 pr-4 text-sm max-w-xs">
                            <div class="truncate">{{ coach.bio|truncatewords:10 }}</div>
                        </td>
                        <td class="py-4 pr-4 text-sm">
                            <span class="text-yellow-500">
                                <i class="fas fa-star"></i> {{ coach.rating|floatformat:1 }}
                            </span>
                            <span class="text-gray-500 text-xs">({{ coach.rating_count }})</span>
                        </td>
                        <td class="py-4 pr-4 text-sm">
                            {{ coach.total_hours_coached_formatted }}
                        </td>
                        <td class="py-4 pr-4">
                            {% if coach.verified %}
                                <span class="px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-700">
                                    <i class="fas fa-certificate"></i> Verified
                                </span>
                            {% else %}
                                <span class="px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-700">
                                    <i class="fas fa-certificate"></i> Not Verified
                                </span>
                            {% endif %}
                        </td>
                        <td class="py-4 pr-4">
                            {% if coach.adminverification %}
                                <div>
                                    <span class="px-2 py-1 rounded-full text-xs font-medium
                                        {% if coach.adminverification.status == 'approved' %}bg-green-100 text-green-700
                                        {% elif coach.adminverification.status == 'rejected' %}bg-red-100 text-red-700
                                        {% else %}bg-yellow-100 text-yellow-700{% endif %}">
                                        {% if coach.adminverification.status == 'approved' %}
                                            <i class="fas fa-check-circle"></i> Can Train
                                        {% elif coach.adminverification.status == 'rejected' %}
                                            <i class="fas fa-ban"></i> Cannot Train
                                        {% else %}
                                            <i class="fas fa-clock"></i> Pending Review
                                        {% endif %}
                                    </span>
                                    {% if coach.adminverification.notes %}
                                        <div class="text-xs text-gray-500 mt-1" title="{{ coach.adminverification.notes }}">
                                            {{ coach.adminverification.notes|truncatewords:5 }}
                                        </div>
                                    {% endif %}
                                </div>
                            {% else %}
                                <span class="px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-700">
                                    <i class="fas fa-clock"></i> Pending Review
                                </span>
                            {% endif %}
                        </td>
                        <td class="py-4">
                            <div class="flex space-x-2">
                                <a href="{% url 'admin_panel:coach_verification_detail' coach.id %}" class="text-green-600 hover:text-green-800 text-sm" title="Manage Approval & Badge">
                                    <i class="fas fa-user-check"></i>
                                </a>
                                <form method="POST" action="{% url 'admin_panel:coach_verify' coach.id %}" class="inline">
                                    {% csrf_token %}
                                    {% if coach.verified %}
                                        <input type="hidden" name="action" value="unverify">
                                        <button type="submit" class="text-orange-600 hover:text-orange-800 text-sm" title="Remove Badge (Quick Toggle)">
                                            <i class="fas fa-certificate"></i>
                                        </button>
                                    {% else %}
                                        <input type="hidden" name="action" value="verify">
                                        <button type="submit" class="text-blue-600 hover:text-blue-800 text-sm" title="Add Badge (Quick Toggle)">
                                            <i class="far fa-certificate"></i>
                                        </button>
                                    {% endif %}
                                </form>
                                <a href="{% url 'admin_panel:coach_delete' coach.id %}" class="text-red-600 hover:text-red-800 text-sm" title="Delete">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    {% empty %}
                    <tr>
                        <td colspan="8" class="py-8 text-center text-gray-500">No coaches found</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
        {% if paginator.num_pages > 1 %}
        <div class="mt-6 flex items-center justify-between">
            <div class="text-sm text-gray-600">
                Showing page <strong>{{ coaches.number }}</strong> of <strong>{{ paginator.num_pages }}</strong>
                ({{ paginator.count }} total coaches)
            </div>
            <nav class="flex gap-2">
                {% if coaches.has_previous %}
                <a href="?page=1&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    First
                </a>
                <a href="?page={{ coaches.previous_page_number }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Previous
                </a>
                {% endif %}
                {% with pages=paginator.page_range %}
                {% if pages|length > 1 %}
                <div class="flex gap-1">
                    {% for page_num in pages %}
                        {% if page_num == coaches.number %}
                        <span class="px-3 py-2 rounded bg-blue-600 text-white font-medium">
                            {{ page_num }}
                        </span>
                        {% elif page_num == '...' %}
                        <span class="px-3 py-2 text-gray-600">...</span>
                        {% else %}
                        <a href="?page={{ page_num }}&search={{ search_query }}&per_page={{ per_page }}"
                           class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                            {{ page_num }}
                        </a>
                        {% endif %}
                    {% endfor %}
                </div>
                {% endif %}
                {% endwith %}
                {% if coaches.has_next %}
                <a href="?page={{ coaches.next_page_number }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Next
                </a>
                <a href="?page={{ paginator.num_pages }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Last
                </a>
                {% endif %}
            </nav>
        </div>
        {% endif %}
    </div>
</div>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/course_delete_confirm.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Delete Course{% endblock %}
{% block content %}
<div class="max-w-2xl mx-auto">
    <div class="bg-white rounded-lg shadow-md">
        <div class="p-6 border-b border-gray-200 bg-red-50">
            <h3 class="text-xl font-semibold text-red-900 flex items-center">
                <i class="fas fa-exclamation-triangle mr-2"></i>
                Confirm Course Deletion
            </h3>
        </div>
        <div class="p-6">
            <p class="text-gray-700 mb-4">
                Are you sure you want to delete this course? This action cannot be undone.
            </p>
            <div class="bg-gray-50 p-4 rounded-lg mb-6">
                <h4 class="font-semibold text-lg mb-2">{{ course.name }}</h4>
                <div class="text-sm space-y-2">
                    <div>
                        <span class="text-gray-600">Coach:</span>
                        <span class="font-medium">{{ course.coach.user.username }}</span>
                    </div>
                    <div>
                        <span class="text-gray-600">Price:</span>
                        <span class="font-medium">Rp {{ course.price|floatformat:0 }}</span>
                    </div>
                    <div>
                        <span class="text-gray-600">Duration:</span>
                        <span class="font-medium">{{ course.duration }} minutes</span>
                    </div>
                </div>
            </div>
            <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-6">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-exclamation-triangle text-yellow-400"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm text-yellow-700">
                            <strong>Warning:</strong> Deleting this course will also delete all associated bookings and payments.
                        </p>
                    </div>
                </div>
            </div>
            <form method="POST" class="flex justify-end space-x-3">
                {% csrf_token %}
                <a href="{% url 'admin_panel:courses' %}" class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors">
                    Cancel
                </a>
                <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
                    <i class="fas fa-trash mr-2"></i>
                    Delete Course
                </button>
            </form>
        </div>
    </div>
</div>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/courses.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Course Management{% endblock %}
{% block content %}
<div class="bg-white rounded-lg shadow-md">
    <div class="p-6 border-b border-gray-200">
        <h3 class="text-xl font-semibold text-gray-900">All Courses</h3>
        <p class="text-sm text-gray-600 mt-1">Manage courses and their details</p>
    </div>
    <div class="p-6">
        <div class="mb-6 bg-gray-50 rounded-lg p-4">
            <form method="GET" class="flex gap-2 flex-wrap items-end">
                <div class="flex-1 min-w-64">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Search</label>
                    <input type="text"
                           name="search"
                           value="{{ search_query }}"
                           placeholder="Search by Course Name, Description, or Coach..."
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Per Page</label>
                    <select name="per_page" class="px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="10" {% if per_page == 10 %}selected{% endif %}>10</option>
                        <option value="25" {% if per_page == 25 %}selected{% endif %}>25</option>
                        <option value="50" {% if per_page == 50 %}selected{% endif %}>50</option>
                    </select>
                </div>
                <input type="hidden" name="page" value="1">
                <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium">
                    Search
                </button>
                <a href="?" class="px-4 py-2 bg-gray-400 text-white rounded-lg hover:bg-gray-500 font-medium">
                    Reset
                </a>
            </form>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                    <tr class="text-left text-xs font-semibold text-gray-600 uppercase border-b-2 border-gray-200">
                        <th class="pb-3 pr-4">ID</th>
                        <th class="pb-3 pr-4">Course Name</th>
                        <th class="pb-3 pr-4">Coach</th>
                        <th class="pb-3 pr-4">Category</th>
                        <th class="pb-3 pr-4">Price</th>
                        <th class="pb-3 pr-4">Duration</th>
                        <th class="pb-3 pr-4">Status</th>
                        <th class="pb-3">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {% for course in courses %}
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="py-4 pr-4">{{ course.id }}</td>
                        <td class="py-4 pr-4">
                            <div class="flex items-center">
                                <div class="w-12 h-12 rounded bg-gray-300 mr-3 flex items-center justify-center">
                                    <i class="fas fa-book text-gray-600"></i>
                                </div>
                                <span class="font-medium">{{ course.title }}</span>
                            </div>
                        </td>
                        <td class="py-4 pr-4">
                            {% if course.coach %}
                                {{ course.coach.user.get_full_name }}
                            {% else %}
                                —
                            {% endif %}
                        </td>
                        <td class="py-4 pr-4">{{ course.category|default:"—" }}</td>
                        <td class="py-4 pr-4 font-semibold text-green-600">Rp {{ course.price|floatformat:0 }}</td>
                        <td class="py-4 pr-4">
                            {{ course.duration }} min
                        </td>
                        <td class="py-4 pr-4">
                            <span class="px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-700">
                                Active
                            </span>
                        </td>
                        <td class="py-4">
                            <div class="flex space-x-2">
                                <a href="{% url 'admin_panel:course_delete' course.id %}" class="text-red-600 hover:text-red-800 text-sm" title="Delete">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    {% empty %}
                    <tr>
                        <td colspan="8" class="py-8 text-center text-gray-500">No courses found</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
        {% if paginator.num_pages > 1 %}
        <div class="mt-6 flex items-center justify-between">
            <div class="text-sm text-gray-600">
                Showing page <strong>{{ courses.number }}</strong> of <strong>{{ paginator.num_pages }}</strong>
                ({{ paginator.count }} total courses)
            </div>
            <nav class="flex gap-2">
                {% if courses.has_previous %}
                <a href="?page=1&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    First
                </a>
                <a href="?page={{ courses.previous_page_number }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Previous
                </a>
                {% endif %}
                {% with pages=paginator.page_range %}
                {% if pages|length > 1 %}
                <div class="flex gap-1">
                    {% for page_num in pages %}
                        {% if page_num == courses.number %}
                        <span class="px-3 py-2 rounded bg-blue-600 text-white font-medium">
                            {{ page_num }}
                        </span>
                        {% elif page_num == '...' %}
                        <span class="px-3 py-2 text-gray-600">...</span>
                        {% else %}
                        <a href="?page={{ page_num }}&search={{ search_query }}&per_page={{ per_page }}"
                           class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                            {{ page_num }}
                        </a>
                        {% endif %}
                    {% endfor %}
                </div>
                {% endif %}
                {% endwith %}
                {% if courses.has_next %}
                <a href="?page={{ courses.next_page_number }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Next
                </a>
                <a href="?page={{ paginator.num_pages }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Last
                </a>
                {% endif %}
            </nav>
        </div>
        {% endif %}
    </div>
</div>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/dashboard.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Dashboard{% endblock %}
{% block content %}
<div class="space-y-6">
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-600 text-sm font-medium">Total Users</p>
                    <p class="text-3xl font-bold text-gray-900 mt-2">{{ total_users }}</p>
                </div>
                <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                    <i class="fas fa-users text-blue-600 text-xl"></i>
                </div>
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-600 text-sm font-medium">Total Coaches</p>
                    <p class="text-3xl font-bold text-gray-900 mt-2">{{ total_coaches }}</p>
                </div>
                <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                    <i class="fas fa-chalkboard-teacher text-green-600 text-xl"></i>
                </div>
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-600 text-sm font-medium">Total Courses</p>
                    <p class="text-3xl font-bold text-gray-900 mt-2">{{ total_courses }}</p>
                </div>
                <div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                    <i class="fas fa-book text-purple-600 text-xl"></i>
                </div>
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-600 text-sm font-medium">Total Revenue</p>
                    <p class="text-3xl font-bold text-gray-900 mt-2">Rp {{ total_revenue|floatformat:0 }}</p>
                </div>
                <div class="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center">
                    <i class="fas fa-dollar-sign text-yellow-600 text-xl"></i>
                </div>
            </div>
        </div>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div class="bg-white rounded-lg shadow-md p-6">
            <p class="text-gray-600 text-sm font-medium">Total Bookings</p>
            <p class="text-2xl font-bold text-gray-900 mt-2">{{ total_bookings }}</p>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6">
            <p class="text-gray-600 text-sm font-medium">Pending Bookings</p>
            <p class="text-2xl font-bold text-orange-600 mt-2">{{ pending_bookings }}</p>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6">
            <p class="text-gray-600 text-sm font-medium">Confirmed Bookings</p>
            <p class="text-2xl font-bold text-green-600 mt-2">{{ confirmed_bookings }}</p>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6">
            <p class="text-gray-600 text-sm font-medium">Completed Bookings</p>
            <p class="text-2xl font-bold text-blue-600 mt-2">{{ done_bookings }}</p>
        </div>
    </div>
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div class="bg-white rounded-lg shadow-md p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">Recent Bookings</h3>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead>
                        <tr class="text-left text-xs font-semibold text-gray-600 uppercase border-b">
                            <th class="pb-3">User</th>
                            <th class="pb-3">Course</th>
                            <th class="pb-3">Status</th>
                            <th class="pb-3">Amount</th>
                        </tr>
                    </thead>
                    <tbody class="text-sm">
                        {% for booking in recent_bookings %}
                        <tr class="border-b last:border-0">
                            <td class="py-3">{{ booking.user.username }}</td>
                            <td class="py-3">{{ booking.course.title|truncatewords:3 }}</td>
                            <td class="py-3">
                                <span class="px-2 py-1 rounded-full text-xs font-medium
                                    {% if booking.status == 'pending' %}bg-orange-100 text-orange-700
                                    {% elif booking.status == 'paid' or booking.status == 'confirmed' %}bg-green-100 text-green-700
                                    {% elif booking.status == 'done' %}bg-blue-100 text-blue-700
                                    {% else %}bg-gray-100 text-gray-700{% endif %}">
                                    {{ booking.status }}
                                </span>
                            </td>
                            <td class="py-3">Rp {{ booking.course.price|floatformat:0 }}</td>
                        </tr>
                        {% empty %}
                        <tr>
                            <td colspan="4" class="py-4 text-center text-gray-500">No recent bookings</td>
                        </tr>
                        {% endfor %}
                    </tbody>
                </table>
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">Recent Activity</h3>
            <div class="space-y-3">
                {% for log in recent_logs %}
                <div class="flex items-start space-x-3 pb-3 border-b last:border-0">
                    <div class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center flex-shrink-0">
                        <i class="fas fa-user text-gray-600 text-xs"></i>
                    </div>
                    <div class="flex-1">
                        <p class="text-sm text-gray-900">
                            <strong>{{ log.admin_user.username }}</strong> {{ log.action }}
                        </p>
                        <p class="text-xs text-gray-500">{{ log.timestamp|timesince }} ago</p>
                        {% if log.description %}
                        <p class="text-xs text-gray-600 mt-1">{{ log.description|truncatewords:10 }}</p>
                        {% endif %}
                    </div>
                </div>
                {% empty %}
                <p class="text-sm text-gray-500 text-center py-4">No recent activity</p>
                {% endfor %}
            </div>
        </div>
    </div>
</div>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/login.html
````html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - MamiCoach</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-gray-900 to-gray-800 min-h-screen flex items-center justify-center">
    <div class="bg-white rounded-lg shadow-2xl w-full max-w-md p-8">
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">MamiCoach</h1>
            <p class="text-gray-600">Admin Panel Login</p>
        </div>
        {% if messages %}
            {% for message in messages %}
            <div class="mb-4 p-4 rounded-lg {% if message.tags == 'error' %}bg-red-100 border-red-500 text-red-800{% else %}bg-blue-100 border-blue-500 text-blue-800{% endif %} border-l-4">
                {{ message }}
            </div>
            {% endfor %}
        {% endif %}
        <form method="post" class="space-y-6">
            {% csrf_token %}
            <div>
                <label for="username" class="block text-sm font-medium text-gray-700 mb-2">Username</label>
                <input
                    type="text"
                    id="username"
                    name="username"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none transition"
                    placeholder="Enter your username"
                >
            </div>
            <div>
                <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password</label>
                <input
                    type="password"
                    id="password"
                    name="password"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none transition"
                    placeholder="Enter your password"
                >
            </div>
            <button
                type="submit"
                class="w-full bg-green-500 hover:bg-green-600 text-white font-semibold py-3 rounded-lg transition duration-200 shadow-lg hover:shadow-xl"
            >
                Login
            </button>
        </form>
    </div>
</body>
</html>
````

## File: admin_panel/templates/admin_panel/logs.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Activity Logs{% endblock %}
{% block content %}
<div class="bg-white rounded-lg shadow-md">
    <div class="p-6 border-b border-gray-200">
        <h3 class="text-xl font-semibold text-gray-900">Admin Activity Logs</h3>
        <p class="text-sm text-gray-600 mt-1">Track all administrative actions and changes</p>
    </div>
    <div class="p-6">
        <div class="mb-4 flex gap-2 flex-wrap">
            <a href="?action=all" class="px-4 py-2 rounded-lg text-sm font-medium {% if not request.GET.action or request.GET.action == 'all' %}bg-gray-900 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                All
            </a>
            <a href="?action=view" class="px-4 py-2 rounded-lg text-sm font-medium {% if request.GET.action == 'view' %}bg-blue-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                View
            </a>
            <a href="?action=create" class="px-4 py-2 rounded-lg text-sm font-medium {% if request.GET.action == 'create' %}bg-green-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Create
            </a>
            <a href="?action=update" class="px-4 py-2 rounded-lg text-sm font-medium {% if request.GET.action == 'update' %}bg-yellow-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Update
            </a>
            <a href="?action=delete" class="px-4 py-2 rounded-lg text-sm font-medium {% if request.GET.action == 'delete' %}bg-red-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Delete
            </a>
            <a href="?action=login" class="px-4 py-2 rounded-lg text-sm font-medium {% if request.GET.action == 'login' %}bg-purple-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Login
            </a>
            <a href="?action=logout" class="px-4 py-2 rounded-lg text-sm font-medium {% if request.GET.action == 'logout' %}bg-gray-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Logout
            </a>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                    <tr class="text-left text-xs font-semibold text-gray-600 uppercase border-b-2 border-gray-200">
                        <th class="pb-3 pr-4">Timestamp</th>
                        <th class="pb-3 pr-4">User</th>
                        <th class="pb-3 pr-4">Action</th>
                        <th class="pb-3 pr-4">Details</th>
                        <th class="pb-3 pr-4">IP Address</th>
                        <th class="pb-3">User Agent</th>
                    </tr>
                </thead>
                <tbody>
                    {% for log in logs %}
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="py-4 pr-4 text-sm text-gray-600">
                            {{ log.timestamp|date:"Y-m-d H:i:s" }}
                        </td>
                        <td class="py-4 pr-4 font-medium">{{ log.admin_user.username }}</td>
                        <td class="py-4 pr-4">
                            <span class="px-2 py-1 rounded-full text-xs font-medium
                                {% if log.action == 'create' %}bg-green-100 text-green-700
                                {% elif log.action == 'update' %}bg-yellow-100 text-yellow-700
                                {% elif log.action == 'delete' %}bg-red-100 text-red-700
                                {% elif log.action == 'view' %}bg-blue-100 text-blue-700
                                {% elif log.action == 'login' %}bg-purple-100 text-purple-700
                                {% elif log.action == 'logout' %}bg-gray-100 text-gray-700
                                {% else %}bg-gray-100 text-gray-700{% endif %}">
                                {{ log.action }}
                            </span>
                        </td>
                        <td class="py-4 pr-4 text-sm">
                            {% if log.details %}
                                {{ log.details|truncatewords:15 }}
                            {% else %}
                                —
                            {% endif %}
                        </td>
                        <td class="py-4 pr-4 text-sm font-mono">{{ log.ip_address|default:"—" }}</td>
                        <td class="py-4 text-xs text-gray-500" title="{{ log.user_agent }}">
                            {{ log.user_agent|truncatewords:5|default:"—" }}
                        </td>
                    </tr>
                    {% empty %}
                    <tr>
                        <td colspan="6" class="py-8 text-center text-gray-500">No activity logs found</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
        {% if logs.has_other_pages %}
        <div class="mt-6 flex justify-center">
            <nav class="flex gap-2">
                {% if logs.has_previous %}
                <a href="?page={{ logs.previous_page_number }}" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded text-sm">
                    Previous
                </a>
                {% endif %}
                <span class="px-4 py-2 bg-green-500 text-white rounded text-sm">
                    Page {{ logs.number }} of {{ logs.paginator.num_pages }}
                </span>
                {% if logs.has_next %}
                <a href="?page={{ logs.next_page_number }}" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded text-sm">
                    Next
                </a>
                {% endif %}
            </nav>
        </div>
        {% endif %}
    </div>
</div>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/payments.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Payment Management{% endblock %}
{% block content %}
<div class="bg-white rounded-lg shadow-md">
    <div class="p-6 border-b border-gray-200">
        <h3 class="text-xl font-semibold text-gray-900">All Payments</h3>
        <p class="text-sm text-gray-600 mt-1">Track and manage payment transactions</p>
    </div>
    <div class="p-6">
        <div class="mb-6 bg-gray-50 rounded-lg p-4">
            <form method="GET" class="flex gap-2 flex-wrap items-end">
                <div class="flex-1 min-w-64">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Search</label>
                    <input type="text"
                           name="search"
                           value="{{ search_query }}"
                           placeholder="Search by Order ID, Username, Email, or Booking ID..."
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Per Page</label>
                    <select name="per_page" class="px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="10" {% if per_page == 10 %}selected{% endif %}>10</option>
                        <option value="25" {% if per_page == 25 %}selected{% endif %}>25</option>
                        <option value="50" {% if per_page == 50 %}selected{% endif %}>50</option>
                    </select>
                </div>
                <input type="hidden" name="status" value="{{ status }}">
                <input type="hidden" name="page" value="1">
                <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium">
                    Search
                </button>
                <a href="?status=all" class="px-4 py-2 bg-gray-400 text-white rounded-lg hover:bg-gray-500 font-medium">
                    Reset
                </a>
            </form>
        </div>
        <div class="mb-4 flex gap-2 flex-wrap">
            <a href="?status=all" class="px-4 py-2 rounded-lg text-sm font-medium {% if not status or status == 'all' %}bg-gray-900 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                All
            </a>
            <a href="?status=pending" class="px-4 py-2 rounded-lg text-sm font-medium {% if status == 'pending' %}bg-orange-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Pending
            </a>
            <a href="?status=settlement" class="px-4 py-2 rounded-lg text-sm font-medium {% if status == 'settlement' %}bg-green-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Success
            </a>
            <a href="?status=expire" class="px-4 py-2 rounded-lg text-sm font-medium {% if status == 'expire' %}bg-red-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Expired
            </a>
            <a href="?status=cancel" class="px-4 py-2 rounded-lg text-sm font-medium {% if status == 'cancel' %}bg-gray-500 text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}">
                Cancelled
            </a>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                    <tr class="text-left text-xs font-semibold text-gray-600 uppercase border-b-2 border-gray-200">
                        <th class="pb-3 pr-4">Order ID</th>
                        <th class="pb-3 pr-4">Booking</th>
                        <th class="pb-3 pr-4">User</th>
                        <th class="pb-3 pr-4">Payment Method</th>
                        <th class="pb-3 pr-4">Amount</th>
                        <th class="pb-3 pr-4">Status</th>
                        <th class="pb-3 pr-4">Created</th>
                        <th class="pb-3">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {% for payment in payments %}
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="py-4 pr-4 font-mono text-sm">{{ payment.order_id }}</td>
                        <td class="py-4 pr-4">#{{ payment.booking.id }}</td>
                        <td class="py-4 pr-4">{{ payment.booking.user.username }}</td>
                        <td class="py-4 pr-4">
                            <span class="px-2 py-1 bg-gray-100 rounded text-xs">
                                {% if payment.method %}
                                    {{ payment.get_method_display }}
                                {% else %}
                                    <span class="text-gray-400">—</span>
                                {% endif %}
                            </span>
                        </td>
                        <td class="py-4 pr-4 font-semibold">Rp {{ payment.amount|floatformat:0 }}</td>
                        <td class="py-4 pr-4">
                            <span class="px-2 py-1 rounded-full text-xs font-medium
                                {% if payment.is_successful %}bg-green-100 text-green-700
                                {% elif payment.is_pending %}bg-orange-100 text-orange-700
                                {% elif payment.is_failed %}bg-red-100 text-red-700
                                {% else %}bg-gray-100 text-gray-700{% endif %}">
                                {{ payment.status }}
                            </span>
                        </td>
                        <td class="py-4 pr-4 text-sm text-gray-600">{{ payment.created_at|date:"Y-m-d H:i" }}</td>
                        <td class="py-4">
                            <div class="flex space-x-2">
                                <form method="POST" action="{% url 'admin_panel:payment_update_status' payment.id %}" class="inline">
                                    {% csrf_token %}
                                    <select name="status" onchange="this.form.submit()" class="text-xs border border-gray-300 rounded px-2 py-1">
                                        <option value="">Change Status</option>
                                        <option value="pending" {% if payment.status == 'pending' %}selected{% endif %}>Pending</option>
                                        <option value="settlement" {% if payment.status == 'settlement' %}selected{% endif %}>Settlement</option>
                                        <option value="capture" {% if payment.status == 'capture' %}selected{% endif %}>Capture</option>
                                        <option value="deny" {% if payment.status == 'deny' %}selected{% endif %}>Deny</option>
                                        <option value="cancel" {% if payment.status == 'cancel' %}selected{% endif %}>Cancel</option>
                                        <option value="expire" {% if payment.status == 'expire' %}selected{% endif %}>Expire</option>
                                        <option value="failure" {% if payment.status == 'failure' %}selected{% endif %}>Failure</option>
                                    </select>
                                </form>
                                <button onclick="showPaymentDetails('{{ payment.order_id }}', '{{ payment.midtrans_response|escapejs }}')"
                                        class="text-blue-600 hover:text-blue-800 text-sm" title="View Details">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    {% empty %}
                    <tr>
                        <td colspan="8" class="py-8 text-center text-gray-500">No payments found</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
        {% if paginator.num_pages > 1 %}
        <div class="mt-6 flex items-center justify-between">
            <div class="text-sm text-gray-600">
                Showing page <strong>{{ payments.number }}</strong> of <strong>{{ paginator.num_pages }}</strong>
                ({{ paginator.count }} total payments)
            </div>
            <nav class="flex gap-2">
                {% if payments.has_previous %}
                <a href="?page=1&status={{ status }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    First
                </a>
                <a href="?page={{ payments.previous_page_number }}&status={{ status }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Previous
                </a>
                {% endif %}
                {% with pages=paginator.page_range %}
                {% if pages|length > 1 %}
                <div class="flex gap-1">
                    {% for page_num in pages %}
                        {% if page_num == payments.number %}
                        <span class="px-3 py-2 rounded bg-blue-600 text-white font-medium">
                            {{ page_num }}
                        </span>
                        {% elif page_num == '...' %}
                        <span class="px-3 py-2 text-gray-600">...</span>
                        {% else %}
                        <a href="?page={{ page_num }}&status={{ status }}&search={{ search_query }}&per_page={{ per_page }}"
                           class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                            {{ page_num }}
                        </a>
                        {% endif %}
                    {% endfor %}
                </div>
                {% endif %}
                {% endwith %}
                {% if payments.has_next %}
                <a href="?page={{ payments.next_page_number }}&status={{ status }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Next
                </a>
                <a href="?page={{ paginator.num_pages }}&status={{ status }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Last
                </a>
                {% endif %}
            </nav>
        </div>
        {% endif %}
    </div>
</div>
<div id="paymentModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
    <div class="bg-white rounded-lg shadow-xl max-w-2xl w-full mx-4 max-h-[80vh] overflow-y-auto">
        <div class="p-6 border-b border-gray-200 flex justify-between items-center">
            <h3 class="text-xl font-semibold text-gray-900">Payment Details</h3>
            <button onclick="closeModal()" class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="p-6">
            <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-2">Order ID</label>
                <p id="modalOrderId" class="font-mono text-sm bg-gray-100 p-2 rounded"></p>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Midtrans Response</label>
                <pre id="modalResponse" class="bg-gray-100 p-4 rounded text-xs overflow-x-auto"></pre>
            </div>
        </div>
    </div>
</div>
<script>
function showPaymentDetails(orderId, response) {
    document.getElementById('modalOrderId').textContent = orderId;
    try {
        const formatted = JSON.stringify(JSON.parse(response), null, 2);
        document.getElementById('modalResponse').textContent = formatted;
    } catch (e) {
        document.getElementById('modalResponse').textContent = response;
    }
    document.getElementById('paymentModal').classList.remove('hidden');
}
function closeModal() {
    document.getElementById('paymentModal').classList.add('hidden');
}
</script>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/settings.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}System Settings{% endblock %}
{% block content %}
<div class="space-y-6">
    <div class="bg-white rounded-lg shadow-md p-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">Add New Setting</h3>
        <form method="post" action="{% url 'admin_panel:settings' %}" class="grid grid-cols-1 md:grid-cols-3 gap-4">
            {% csrf_token %}
            <input type="hidden" name="action" value="add">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Module</label>
                <select name="module" required class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent">
                    <option value="payment">Payment</option>
                    <option value="booking">Booking</option>
                    <option value="course">Course</option>
                    <option value="user">User</option>
                    <option value="coach">Coach</option>
                    <option value="schedule">Schedule</option>
                    <option value="general">General</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Setting Key</label>
                <input type="text" name="key" required placeholder="e.g., auto_confirm_payment"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent">
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Value</label>
                <div class="flex gap-2">
                    <input type="text" name="value" required placeholder="Setting value"
                           class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent">
                    <button type="submit" class="px-6 py-2 bg-green-500 hover:bg-green-600 text-white rounded-lg font-medium">
                        Add
                    </button>
                </div>
            </div>
        </form>
    </div>
    {% regroup settings by module as module_settings %}
    {% for module_group in module_settings %}
    <div class="bg-white rounded-lg shadow-md">
        <div class="p-6 border-b border-gray-200">
            <h3 class="text-xl font-semibold text-gray-900 capitalize">{{ module_group.grouper }} Module Settings</h3>
        </div>
        <div class="p-6">
            <div class="space-y-4">
                {% for setting in module_group.list %}
                <form method="post" action="{% url 'admin_panel:settings' %}" class="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
                    {% csrf_token %}
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="setting_id" value="{{ setting.id }}">
                    <div class="flex-1 grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Key</label>
                            <input type="text" value="{{ setting.key }}" disabled
                                   class="w-full px-3 py-2 border border-gray-300 rounded bg-gray-100 text-gray-600">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Value</label>
                            <input type="text" name="value" value="{{ setting.value }}"
                                   class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-green-500 focus:border-transparent">
                        </div>
                    </div>
                    <div class="ml-4 flex gap-2">
                        <button type="submit" class="px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded text-sm">
                            Update
                        </button>
                        <button type="submit" formaction="{% url 'admin_panel:settings' %}"
                                onclick="this.form.action.value='delete'"
                                class="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded text-sm">
                            Delete
                        </button>
                    </div>
                </form>
                {% endfor %}
            </div>
        </div>
    </div>
    {% empty %}
    <div class="bg-white rounded-lg shadow-md p-6">
        <p class="text-center text-gray-500">No settings configured yet. Add your first setting above.</p>
    </div>
    {% endfor %}
</div>
<script>
// Prevent double submission
document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', function(e) {
        const submitBtn = this.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.disabled = true;
            setTimeout(() => submitBtn.disabled = false, 2000);
        }
    });
});
</script>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/user_delete_confirm.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}Delete User{% endblock %}
{% block content %}
<div class="max-w-2xl mx-auto">
    <div class="bg-white rounded-lg shadow-md">
        <div class="p-6 border-b border-gray-200 bg-red-50">
            <h3 class="text-xl font-semibold text-red-900 flex items-center">
                <i class="fas fa-exclamation-triangle mr-2"></i>
                Confirm User Deletion
            </h3>
        </div>
        <div class="p-6">
            <p class="text-gray-700 mb-4">
                Are you sure you want to delete this user? This action cannot be undone.
            </p>
            <div class="bg-gray-50 p-4 rounded-lg mb-6">
                <div class="mb-4">
                    <h4 class="font-semibold text-lg">{{ user_obj.get_full_name|default:user_obj.username }}</h4>
                    <p class="text-sm text-gray-600">@{{ user_obj.username }}</p>
                    <p class="text-sm text-gray-600">{{ user_obj.email }}</p>
                </div>
                <div class="grid grid-cols-2 gap-4 text-sm">
                    <div>
                        <span class="text-gray-600">User ID:</span>
                        <span class="font-medium">{{ user_obj.id }}</span>
                    </div>
                    <div>
                        <span class="text-gray-600">Joined:</span>
                        <span class="font-medium">{{ user_obj.date_joined|date:"Y-m-d" }}</span>
                    </div>
                    <div>
                        <span class="text-gray-600">Status:</span>
                        <span class="font-medium">{{ user_obj.is_active|yesno:"Active,Inactive" }}</span>
                    </div>
                </div>
            </div>
            <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-6">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-exclamation-triangle text-yellow-400"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm text-yellow-700">
                            <strong>Warning:</strong> Deleting this user will also delete all associated data including bookings and reviews.
                        </p>
                    </div>
                </div>
            </div>
            <form method="POST" class="flex justify-end space-x-3">
                {% csrf_token %}
                <a href="{% url 'admin_panel:users' %}" class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors">
                    Cancel
                </a>
                <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
                    <i class="fas fa-trash mr-2"></i>
                    Delete User
                </button>
            </form>
        </div>
    </div>
</div>
{% endblock %}
````

## File: admin_panel/templates/admin_panel/users.html
````html
{% extends 'admin_panel/base.html' %}
{% block page_title %}User Management{% endblock %}
{% block content %}
<div class="bg-white rounded-lg shadow-md">
    <div class="p-6 border-b border-gray-200">
        <h3 class="text-xl font-semibold text-gray-900">All Users</h3>
        <p class="text-sm text-gray-600 mt-1">Manage user accounts and profiles</p>
    </div>
    <div class="p-6">
        <div class="mb-6 bg-gray-50 rounded-lg p-4">
            <form method="GET" class="flex gap-2 flex-wrap items-end">
                <div class="flex-1 min-w-64">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Search</label>
                    <input type="text"
                           name="search"
                           value="{{ search_query }}"
                           placeholder="Search by Username, Email, Name..."
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Per Page</label>
                    <select name="per_page" class="px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="10" {% if per_page == 10 %}selected{% endif %}>10</option>
                        <option value="25" {% if per_page == 25 %}selected{% endif %}>25</option>
                        <option value="50" {% if per_page == 50 %}selected{% endif %}>50</option>
                    </select>
                </div>
                <input type="hidden" name="page" value="1">
                <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium">
                    Search
                </button>
                <a href="?" class="px-4 py-2 bg-gray-400 text-white rounded-lg hover:bg-gray-500 font-medium">
                    Reset
                </a>
            </form>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                    <tr class="text-left text-xs font-semibold text-gray-600 uppercase border-b-2 border-gray-200">
                        <th class="pb-3 pr-4">ID</th>
                        <th class="pb-3 pr-4">Username</th>
                        <th class="pb-3 pr-4">Email</th>
                        <th class="pb-3 pr-4">Full Name</th>
                        <th class="pb-3 pr-4">Phone</th>
                        <th class="pb-3 pr-4">Joined</th>
                        <th class="pb-3 pr-4">Status</th>
                        <th class="pb-3">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {% for userprofile in users %}
                    <tr class="border-b border-gray-100 hover:bg-gray-50">
                        <td class="py-4 pr-4">{{ userprofile.user.id }}</td>
                        <td class="py-4 pr-4 font-medium">{{ userprofile.user.username }}</td>
                        <td class="py-4 pr-4">{{ userprofile.user.email|default:"—" }}</td>
                        <td class="py-4 pr-4">{{ userprofile.user.get_full_name|default:"—" }}</td>
                        <td class="py-4 pr-4">—</td>
                        <td class="py-4 pr-4 text-sm text-gray-600">{{ userprofile.user.date_joined|date:"Y-m-d" }}</td>
                        <td class="py-4 pr-4">
                            <span class="px-2 py-1 rounded-full text-xs font-medium
                                {% if userprofile.user.is_active %}bg-green-100 text-green-700{% else %}bg-red-100 text-red-700{% endif %}">
                                {% if userprofile.user.is_active %}Active{% else %}Inactive{% endif %}
                            </span>
                        </td>
                        <td class="py-4">
                            <div class="flex space-x-2">
                                <a href="{% url 'admin_panel:user_delete' userprofile.user.id %}" class="text-red-600 hover:text-red-800 text-sm" title="Delete">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    {% empty %}
                    <tr>
                        <td colspan="8" class="py-8 text-center text-gray-500">No users found</td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
        {% if paginator.num_pages > 1 %}
        <div class="mt-6 flex items-center justify-between">
            <div class="text-sm text-gray-600">
                Showing page <strong>{{ users.number }}</strong> of <strong>{{ paginator.num_pages }}</strong>
                ({{ paginator.count }} total users)
            </div>
            <nav class="flex gap-2">
                {% if users.has_previous %}
                <a href="?page=1&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    First
                </a>
                <a href="?page={{ users.previous_page_number }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Previous
                </a>
                {% endif %}
                {% with pages=paginator.page_range %}
                {% if pages|length > 1 %}
                <div class="flex gap-1">
                    {% for page_num in pages %}
                        {% if page_num == users.number %}
                        <span class="px-3 py-2 rounded bg-blue-600 text-white font-medium">
                            {{ page_num }}
                        </span>
                        {% elif page_num == '...' %}
                        <span class="px-3 py-2 text-gray-600">...</span>
                        {% else %}
                        <a href="?page={{ page_num }}&search={{ search_query }}&per_page={{ per_page }}"
                           class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                            {{ page_num }}
                        </a>
                        {% endif %}
                    {% endfor %}
                </div>
                {% endif %}
                {% endwith %}
                {% if users.has_next %}
                <a href="?page={{ users.next_page_number }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Next
                </a>
                <a href="?page={{ paginator.num_pages }}&search={{ search_query }}&per_page={{ per_page }}"
                   class="px-3 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-100">
                    Last
                </a>
                {% endif %}
            </nav>
        </div>
        {% endif %}
    </div>
</div>
{% endblock %}
````

## File: admin_panel/admin.py
````python

````

## File: admin_panel/apps.py
````python
class AdminPanelConfig(AppConfig)
⋮----
default_auto_field = "django.db.models.BigAutoField"
name = "admin_panel"
````

## File: admin_panel/models.py
````python
class AdminUser(models.Model)
⋮----
username = models.CharField(max_length=150, unique=True)
password = models.CharField(max_length=128)
email = models.EmailField(unique=True)
is_active = models.BooleanField(default=True)
last_login = models.DateTimeField(null=True, blank=True)
created_at = models.DateTimeField(auto_now_add=True)
class Meta
⋮----
verbose_name = "Admin User"
verbose_name_plural = "Admin Users"
def __str__(self)
def set_password(self, raw_password)
def check_password(self, raw_password)
class AdminSettings(models.Model)
⋮----
key = models.CharField(max_length=255, unique=True, help_text="Setting key")
value = models.TextField(help_text="Setting value (JSON, string, or number)")
description = models.TextField(blank=True, help_text="Description of this setting")
module = models.CharField(max_length=100, help_text="Module this setting belongs to (e.g., 'booking', 'payment', 'courses')")
⋮----
updated_at = models.DateTimeField(auto_now=True)
updated_by = models.ForeignKey('AdminUser', on_delete=models.SET_NULL, null=True, blank=True)
⋮----
ordering = ['module', 'key']
verbose_name = "Admin Setting"
verbose_name_plural = "Admin Settings"
⋮----
class AdminActivityLog(models.Model)
⋮----
ACTION_CHOICES = [
admin_user = models.ForeignKey('AdminUser', on_delete=models.CASCADE, related_name='admin_activities')
action = models.CharField(max_length=20, choices=ACTION_CHOICES)
module = models.CharField(max_length=100, help_text="Module where action was performed")
description = models.TextField(help_text="Description of the action")
ip_address = models.GenericIPAddressField(null=True, blank=True)
user_agent = models.TextField(blank=True)
timestamp = models.DateTimeField(auto_now_add=True)
⋮----
ordering = ['-timestamp']
verbose_name = "Admin Activity Log"
verbose_name_plural = "Admin Activity Logs"
indexes = [
````

## File: admin_panel/urls.py
````python
app_name = 'admin_panel'
urlpatterns = [
````

## File: admin_panel/views.py
````python
def admin_login_required(view_func)
⋮----
@wraps(view_func)
    def wrapper(request, *args, **kwargs)
⋮----
admin_user = AdminUser.objects.get(id=request.session['admin_user_id'], is_active=True)
⋮----
def log_admin_activity(admin_user, action, module, description, request=None)
⋮----
ip_address = None
user_agent = ''
⋮----
x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
⋮----
ip_address = x_forwarded_for.split(',')[0]
⋮----
ip_address = request.META.get('REMOTE_ADDR')
user_agent = request.META.get('HTTP_USER_AGENT', '')
⋮----
def paginate_queryset(request, queryset, per_page=10)
⋮----
per_page_param = request.GET.get('per_page', per_page)
⋮----
per_page_param = int(per_page_param)
⋮----
per_page_param = per_page
⋮----
paginator = Paginator(queryset, per_page_param)
page = request.GET.get('page')
⋮----
items = paginator.page(page)
⋮----
items = paginator.page(1)
⋮----
items = paginator.page(paginator.num_pages)
⋮----
@require_http_methods(["GET", "POST"])
def admin_login(request)
⋮----
username = request.POST.get('username')
password = request.POST.get('password')
⋮----
admin_user = AdminUser.objects.get(username=username, is_active=True)
⋮----
@admin_login_required
def admin_logout(request)
⋮----
@admin_login_required
def dashboard(request)
⋮----
total_users = UserProfile.objects.count()
total_coaches = CoachProfile.objects.count()
total_courses = Course.objects.count()
total_bookings = Booking.objects.count()
pending_bookings = Booking.objects.filter(status='pending').count()
confirmed_bookings = Booking.objects.filter(status='confirmed').count()
done_bookings = Booking.objects.filter(status='done').count()
recent_bookings = Booking.objects.select_related('user', 'course').order_by('-created_at')[:10]
total_revenue = Payment.objects.filter(status__in=['settlement', 'capture']).aggregate(
recent_logs = AdminActivityLog.objects.select_related('admin_user').order_by('-timestamp')[:10]
⋮----
context = {
⋮----
@admin_login_required
def users_management(request)
⋮----
users = UserProfile.objects.select_related('user').order_by('-user__date_joined')
search_query = request.GET.get('search', '').strip()
⋮----
users = users.filter(
⋮----
@admin_login_required
def coaches_management(request)
⋮----
coaches = CoachProfile.objects.select_related('user').prefetch_related('adminverification').order_by('-id')
⋮----
coaches = coaches.filter(
⋮----
@admin_login_required
def courses_management(request)
⋮----
courses = Course.objects.select_related('coach').order_by('-id')
⋮----
courses = courses.filter(
⋮----
@admin_login_required
def bookings_management(request)
⋮----
bookings = Booking.objects.select_related('user', 'course').order_by('-created_at')
status = request.GET.get('status', 'all')
⋮----
bookings = bookings.filter(status=status)
⋮----
bookings = bookings.filter(
⋮----
@admin_login_required
def payments_management(request)
⋮----
payments = Payment.objects.select_related('booking__user', 'booking__course').order_by('-created_at')
⋮----
payments = payments.filter(status=status)
⋮----
payments = payments.filter(
⋮----
@admin_login_required
def settings_management(request)
⋮----
action = request.POST.get('action')
⋮----
module = request.POST.get('module')
key = request.POST.get('key')
value = request.POST.get('value')
⋮----
setting_id = request.POST.get('setting_id')
setting = get_object_or_404(AdminSettings, id=setting_id)
old_value = setting.value
⋮----
key = setting.key
⋮----
settings = AdminSettings.objects.all().order_by('module', 'key')
⋮----
@admin_login_required
def activity_logs(request)
⋮----
action_filter = request.GET.get('action', 'all')
⋮----
logs = AdminActivityLog.objects.filter(action=action_filter).select_related('admin_user').order_by('-timestamp')[:500]
⋮----
logs = AdminActivityLog.objects.select_related('admin_user').order_by('-timestamp')[:500]
⋮----
@admin_login_required
def change_password(request)
⋮----
old_password = request.POST.get('old_password')
new_password1 = request.POST.get('new_password1')
new_password2 = request.POST.get('new_password2')
⋮----
@admin_login_required
def coach_verify(request, coach_id)
⋮----
coach = get_object_or_404(CoachProfile, id=coach_id)
⋮----
# Remove verified badge - doesn't affect approval status
⋮----
@admin_login_required
def coach_verification_detail(request, coach_id)
⋮----
notes = request.POST.get('notes', '')
⋮----
badge_action = 'added' if coach.verified else 'removed'
⋮----
@admin_login_required
def coach_delete(request, coach_id)
⋮----
username = coach.user.username
user = coach.user
⋮----
@admin_login_required
def user_delete(request, user_id)
⋮----
user_obj = get_object_or_404(User, id=user_id)
⋮----
username = user_obj.username
⋮----
@admin_login_required
def course_delete(request, course_id)
⋮----
course = get_object_or_404(Course, id=course_id)
⋮----
course_name = course.title
⋮----
@admin_login_required
def booking_update_status(request, booking_id)
⋮----
booking = get_object_or_404(Booking, id=booking_id)
⋮----
new_status = request.POST.get('status')
old_status = booking.status
⋮----
@admin_login_required
def booking_delete(request, booking_id)
⋮----
booking_info = f"#{booking.id} - {booking.user.username} - {booking.course.title}"
⋮----
@admin_login_required
def payment_update_status(request, payment_id)
⋮----
payment = get_object_or_404(Payment, id=payment_id)
⋮----
old_status = payment.status
````

## File: booking/migrations/0001_initial.py
````python
class Migration(migrations.Migration)
⋮----
initial = True
dependencies = [
operations = [
````

## File: booking/services/__init__.py
````python

````

## File: booking/services/availability.py
````python
def merge_intervals(intervals: List[Tuple[dt_time, dt_time]]) -> List[Tuple[dt_time, dt_time]]
⋮----
def time_to_minutes(t)
def minutes_to_time(m)
sorted_intervals = sorted(intervals, key=lambda x: time_to_minutes(x[0]))
merged = []
⋮----
current_start_min = time_to_minutes(current_start)
current_end_min = time_to_minutes(current_end)
⋮----
start_min = time_to_minutes(start)
end_min = time_to_minutes(end)
⋮----
current_end_min = max(current_end_min, end_min)
⋮----
current_start_min = start_min
current_end_min = end_min
⋮----
busy_merged = merge_intervals(busy_intervals)
free_intervals = []
⋮----
avail_start_min = time_to_minutes(avail_start)
avail_end_min = time_to_minutes(avail_end)
current_free_start = avail_start_min
⋮----
busy_start_min = time_to_minutes(busy_start)
busy_end_min = time_to_minutes(busy_end)
⋮----
# Move current free start to after busy interval
current_free_start = max(current_free_start, busy_end_min)
# Add remaining free time after all busy intervals
⋮----
start_times = []
⋮----
start_min = time_to_minutes(interval_start)
end_min = time_to_minutes(interval_end)
current = start_min
# Enumerate start times with step_minutes increments
⋮----
def get_available_start_times(coach, course, target_date: dt_date, step_minutes: int = 30) -> List[str]
⋮----
# Get coach's availability for the date
availabilities = CoachAvailability.objects.filter(
⋮----
available_intervals = list(availabilities)
jakarta_tz = pytz.timezone('Asia/Jakarta')
utc_tz = pytz.UTC
start_of_day_local = jakarta_tz.localize(datetime.combine(target_date, dt_time.min))
end_of_day_local = jakarta_tz.localize(datetime.combine(target_date, dt_time.max))
start_of_day = start_of_day_local.astimezone(utc_tz)
end_of_day = end_of_day_local.astimezone(utc_tz)
active_bookings = Booking.objects.filter(
busy_intervals = []
⋮----
booking_start = utc_tz.localize(booking_start)
⋮----
booking_end = utc_tz.localize(booking_end)
local_start = timezone.localtime(booking_start, jakarta_tz)
local_end = timezone.localtime(booking_end, jakarta_tz)
⋮----
free_intervals = subtract_busy(available_intervals, busy_intervals)
duration_minutes = course.duration
start_times_obj = enumerate_starts(free_intervals, duration_minutes, step_minutes)
start_times_str = [t.strftime('%H:%M') for t in start_times_obj]
````

## File: booking/templates/booking/booking_card.html
````html
{% load static %}
<div class="sticky top-8 ">
    <div class="bg-white rounded-3xl shadow-xl p-6 border border-gray-100">
        <div class="text-center mb-6">
            <div class="text-3xl font-bold text-gray-900 mb-1">
                {{ course.price_formatted }}<span class="text-sm font-normal text-gray-500">/sesi</span>
            </div>
            {% if course.coach.verified %}
            <div class="flex items-center justify-center space-x-2 text-primary">
                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M10 15l-5.878 3.09 1.123-6.545L.489 6.91l6.572-.955L10 0l2.939 5.955 6.572.955-4.756 4.635 1.123 6.545z"/>
                </svg>
                {% if course.coach.verified %}
                    <span class="text-sm font-medium">Verified Coach</span>
                {% endif %}
            </div>
            {% endif %}
        </div>
        <button
            onclick="openBookingModal()"
            class="w-full bg-primary text-white py-4 rounded-2xl font-semibold text-lg hover:bg-green-600 transition-colors duration-200 flex items-center justify-center space-x-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
            </svg>
            <span>Pesan Sekarang</span>
        </button>
        <div class="mt-6 pt-6 border-t border-gray-200">
            <div class="flex items-center space-x-4">
                <div class="w-16 h-16 rounded-full overflow-hidden bg-gray-200">
                    {% if course.coach.image_url %}
                        <img
                            src="{{ course.coach.image_url }}"
                            alt="{{ course.coach.user.get_full_name }}"
                            class="w-full h-full object-cover"
                            onerror="this.src='https://ui-avatars.com/api/?name={{ course.coach.user.get_full_name|urlencode }}&background=35A753&color=ffffff'"
                        >
                    {% else %}
                        <img
                            src="https://ui-avatars.com/api/?name={{ course.coach.user.get_full_name|urlencode }}&background=35A753&color=ffffff"
                            alt="{{ course.coach.user.get_full_name }}"
                            class="w-full h-full object-cover"
                        >
                    {% endif %}
                </div>
                <div class="flex-1">
                    <h4 class="font-semibold text-gray-900">{{ course.coach.user.get_full_name }}</h4>
                    <p class="text-sm text-gray-600">{{ course.category.name }}, {{ course.coach.expertise|join:", " }}</p>
                    <div class="flex items-center space-x-1 mt-1">
                        <svg class="w-4 h-4 text-yellow-400 fill-current" viewBox="0 0 20 20">
                            <path d="M10 15l-5.878 3.09 1.123-6.545L.489 6.91l6.572-.955L10 0l2.939 5.955 6.572.955-4.756 4.635 1.123 6.545z"/>
                        </svg>
                        <span class="text-sm font-medium text-gray-900">{{ course.coach.rating|floatformat:1 }}</span>
                        <span class="text-sm text-gray-500">({{ course.coach.rating_count|default:"0" }})</span>
                    </div>
                </div>
            </div>
            <div class="mt-4 text-sm text-gray-600">
                <div class="flex items-center space-x-2">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    <span>• {{ course.coach.total_hours_coached_formatted }} sesi dijadwalkan</span>
                </div>
            </div>
            <a href="{% url 'courses_and_coach:coach_details' course.coach.id %}" class="w-full mt-4 text-primary border border-primary py-3 rounded-2xl font-semibold hover:bg-primary hover:text-white transition-colors duration-200 flex items-center justify-center space-x-2">
                <span>Lihat profil coach</span>
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                </svg>
            </a>
            <a href="{% url 'chat:presend_course' course.id %}?next={{ request.path|urlencode }}" class="w-full mt-3 text-primary border border-primary py-3 rounded-2xl font-semibold hover:bg-primary hover:text-white transition-colors duration-200 flex items-center justify-center space-x-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-message-circle">
                    <path d="M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719"/>
                </svg>
                <span>Chat dengan coach</span>
            </a>
        </div>
    </div>
</div>
{% load static %}
<div id="bookingModal" class="hidden fixed inset-0 bg-black/50 z-[9999] flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl max-w-2xl w-full z-[9999] max-h-[90vh] mt-20 overflow-y-auto">
        <div class="p-6">
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h2 class="text-2xl font-bold text-gray-900">Pilih Tanggal & Waktu</h2>
                    <p class="text-sm text-gray-600 mt-1">Tentukan jadwal kursus bersama {{ course.coach.user.get_full_name }}</p>
                </div>
                <button onclick="closeBookingModal()" class="text-gray-400 hover:text-gray-600 transition-colors">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            <div>
                <div id="calendarSection">
                    <div class="bg-gray-50 rounded-2xl p-4">
                        <div class="flex items-center justify-between mb-4">
                            <button onclick="previousMonth()" class="p-2 hover:bg-white rounded-lg transition-colors">
                                <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                                </svg>
                            </button>
                            <h3 id="currentMonth" class="text-lg font-bold text-gray-900">Bulan Tahun</h3>
                            <button onclick="nextMonth()" class="p-2 hover:bg-white rounded-lg transition-colors">
                                <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                                </svg>
                            </button>
                        </div>
                        <div class="grid grid-cols-7 gap-1 mb-3">
                            <div class="text-center text-xs font-semibold text-gray-600 py-1">SEN</div>
                            <div class="text-center text-xs font-semibold text-gray-600 py-1">SEL</div>
                            <div class="text-center text-xs font-semibold text-gray-600 py-1">RAB</div>
                            <div class="text-center text-xs font-semibold text-gray-600 py-1">KAM</div>
                            <div class="text-center text-xs font-semibold text-gray-600 py-1">JUM</div>
                            <div class="text-center text-xs font-semibold text-gray-600 py-1">SAB</div>
                            <div class="text-center text-xs font-semibold text-gray-600 py-1">MIN</div>
                    </div>
                        <div id="calendarDays" class="grid grid-cols-7 gap-1">
                        </div>
                        <div class="mt-4 pt-4 border-t border-gray-200">
                            <div class="text-xs text-gray-600 flex items-center space-x-2">
                                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                                <span><span class="font-semibold">Zona Waktu:</span> Waktu Indochina (UTC+7)</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="timeSlotsSection" class="hidden">
                    <div class="bg-gray-50 rounded-2xl p-4">
                        <div class="mb-4">
                            <button onclick="backToCalendar()" class="text-primary hover:text-green-600 flex items-center space-x-1 mb-3 font-medium text-sm">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                                </svg>
                                <span>Kembali ke kalender</span>
                            </button>
                            <h3 id="selectedDateDisplay" class="text-xl font-bold text-gray-900 mb-1">Kamis, 23 Oktober</h3>
                            <p class="text-xs text-gray-600">Pilih waktu yang Anda inginkan</p>
                        </div>
                        <div id="timeSlotsList" class="space-y-2 max-h-80 overflow-y-auto">
                        </div>
                        <button
                            id="nextButton"
                            onclick="confirmBooking()"
                            class="hidden w-full mt-4 bg-primary text-white py-3 rounded-2xl font-semibold hover:bg-green-600 transition-colors duration-200">
                            Next
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    const courseId = {{ course.id }};
    const coachId = {{ course.coach.id }};
    let currentYear = new Date().getFullYear();
    let currentMonth = new Date().getMonth() + 1;
    let selectedDate = null;
    let selectedTime = null; // Changed from selectedSlotId to selectedTime
    let availableDates = [];
    const MONTH_NAMES_ID = {
        January: 'Januari',
        February: 'Februari',
        March: 'Maret',
        April: 'April',
        May: 'Mei',
        June: 'Juni',
        July: 'Juli',
        August: 'Agustus',
        September: 'September',
        October: 'Oktober',
        November: 'November',
        December: 'Desember'
    };
    const WEEKDAY_LABELS_ID = ['SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB', 'MIN'];
    function getCookie(name) {
        let cookieValue = null;
        if (document.cookie && document.cookie !== '') {
            const cookies = document.cookie.split(';');
            for (let i = 0; i < cookies.length; i++) {
                const cookie = cookies[i].trim();
                if (cookie.substring(0, name.length + 1) === (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
    function openBookingModal() {
        // Check if user is authenticated
        const isAuthenticated = {{ request.user.is_authenticated|yesno:"true,false" }};
        const isCoach = {% if request.user.coachprofile %}true{% else %}false{% endif %};
        if (!isAuthenticated) {
            // Show toast notification
            if (typeof showToast === 'function') {
                showToast('Silakan login terlebih dahulu untuk melakukan booking.', 'error');
            }
            // Redirect to login with callback to current course details page after a brief delay
            const currentUrl = window.location.pathname;
            setTimeout(() => {
                window.location.href = `/login?next=${encodeURIComponent(currentUrl)}`;
            }, 1500);
            return;
        }
        if (isCoach) {
            if (typeof showToast === 'function') {
                showToast('Hanya trainee yang dapat melakukan booking.', 'error');
            }
            return;
        }
        document.getElementById('bookingModal').classList.remove('hidden');
        loadCalendar();
    }
    function closeBookingModal() {
        document.getElementById('bookingModal').classList.add('hidden');
        document.getElementById('calendarSection').classList.remove('hidden');
        document.getElementById('timeSlotsSection').classList.add('hidden');
        selectedDate = null;
        selectedSlotId = null;
    }
    function loadCalendar() {
        // Show loading
        const calendarDays = document.getElementById('calendarDays');
        calendarDays.innerHTML = '<div class="col-span-7 text-center py-8 text-gray-500">Loading calendar...</div>';
        // Fetch available dates
    fetch(`/booking/api/coach/${coachId}/available-dates/?year=${currentYear}&month=${currentMonth}&course_id=${courseId}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Calendar data:', data); // Debug
                availableDates = data.available_dates || [];
                renderCalendar(data);
            })
            .catch(error => {
                console.error('Error loading calendar:', error);
                calendarDays.innerHTML = '<div class="col-span-7 text-center py-8 text-red-500">Failed to load calendar</div>';
            });
    }
    function renderCalendar(data) {
    const localizedMonth = MONTH_NAMES_ID[data.month_name] || data.month_name;
    document.getElementById('currentMonth').textContent = `${localizedMonth} ${data.year}`;
        const calendarDays = document.getElementById('calendarDays');
        calendarDays.innerHTML = '';
        const firstDay = new Date(currentYear, currentMonth - 1, 1).getDay();
        const daysInMonth = new Date(currentYear, currentMonth, 0).getDate();
        const adjustedFirstDay = firstDay === 0 ? 6 : firstDay - 1;
        for (let i = 0; i < adjustedFirstDay; i++) {
            const emptyCell = document.createElement('div');
            calendarDays.appendChild(emptyCell);
        }
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        let hasAvailableInThisMonth = false;
        for (let day = 1; day <= daysInMonth; day++) {
            const dateStr = `${currentYear}-${String(currentMonth).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
            const currentDate = new Date(currentYear, currentMonth - 1, day);
            const isAvailable = availableDates.some(d => d.date === dateStr);
            const isPast = currentDate < today;
            const dayCell = document.createElement('div');
            const button = document.createElement('button');
            button.textContent = day;
            // Update: Ukuran button lebih kecil dengan h-10
            button.className = 'w-full h-10 rounded-lg flex items-center justify-center text-sm font-medium transition-all ';
            if (isPast) {
                button.className += 'text-gray-300 cursor-not-allowed bg-gray-50';
                button.disabled = true;
            } else if (isAvailable) {
                button.className += 'bg-green-100 text-green-700 hover:bg-primary hover:text-white cursor-pointer border-2 border-green-300';
                button.onclick = () => selectDate(dateStr);
                hasAvailableInThisMonth = true;
            } else {
                button.className += 'text-gray-400 cursor-not-allowed hover:bg-gray-100';
                button.disabled = true;
            }
            dayCell.appendChild(button);
            calendarDays.appendChild(dayCell);
        }
        // If no available dates in this month, show small red message
        if (!hasAvailableInThisMonth) {
            const messageDiv = document.createElement('div');
            messageDiv.className = 'col-span-7 text-center py-2 mt-2';
            messageDiv.innerHTML = `<p class="text-red-500 text-sm">Tidak ada jadwal di bulan ini</p>`;
            calendarDays.appendChild(messageDiv);
        }
    }
    function selectDate(dateStr) {
        selectedDate = dateStr;
        console.log('Selected date:', dateStr); // Debug
        // Hide calendar, show time slots
        document.getElementById('calendarSection').classList.add('hidden');
        document.getElementById('timeSlotsSection').classList.remove('hidden');
        // Show loading
        document.getElementById('timeSlotsList').innerHTML = '<div class="text-center py-8 text-gray-500">Loading available times...</div>';
        // Fetch available times
        fetch(`/booking/api/coach/${coachId}/available-times/?date=${dateStr}&course_id=${courseId}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Time slots data:', data); // Debug
                renderTimeSlots(data);
                // Update selected date display
                const date = new Date(dateStr);
                const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                const formattedDate = date.toLocaleDateString('id-ID', options);
                document.getElementById('selectedDateDisplay').textContent = formattedDate.charAt(0).toUpperCase() + formattedDate.slice(1);
            })
            .catch(error => {
                console.error('Error loading time slots:', error);
                document.getElementById('timeSlotsList').innerHTML = '<div class="text-center py-8 text-red-500">Failed to load time slots</div>';
            });
    }
    function renderTimeSlots(data) {
        const timeSlotsList = document.getElementById('timeSlotsList');
        if (!data.available_times || data.available_times.length === 0) {
            timeSlotsList.innerHTML = '<div class="text-center py-8 text-gray-500">No available time slots for this date</div>';
            return;
        }
        timeSlotsList.innerHTML = '';
        data.available_times.forEach(slot => {
            const button = document.createElement('button');
            button.className = 'w-full text-center px-6 py-4 rounded-xl border-2 border-gray-200 hover:border-primary hover:bg-primary/5 transition-all font-medium text-gray-900';
            button.textContent = slot.display;
            // Changed: pass time string instead of slot_id
            button.onclick = () => selectTimeSlot(slot.start_time, button);
            timeSlotsList.appendChild(button);
        });
    }
    function selectTimeSlot(timeStr, button) {
        // Remove previous selection
        document.querySelectorAll('#timeSlotsList button').forEach(btn => {
            btn.classList.remove('border-primary', 'bg-primary/10', 'border-green-500', 'bg-green-50');
            btn.classList.add('border-gray-200');
        });
        // Mark as selected
        button.classList.add('border-green-500', 'bg-green-50');
        button.classList.remove('border-gray-200');
        selectedTime = timeStr; // Changed from selectedSlotId
        // Show next button
        document.getElementById('nextButton').classList.remove('hidden');
    }
    function backToCalendar() {
        document.getElementById('timeSlotsSection').classList.add('hidden');
        document.getElementById('calendarSection').classList.remove('hidden');
        document.getElementById('nextButton').classList.add('hidden');
        selectedTime = null; // Changed from selectedSlotId
    }
    function previousMonth() {
        if (currentMonth === 1) {
            currentMonth = 12;
            currentYear--;
        } else {
            currentMonth--;
        }
        loadCalendar();
    }
    function nextMonth() {
        if (currentMonth === 12) {
            currentMonth = 1;
            currentYear++;
        } else {
            currentMonth++;
        }
        loadCalendar();
    }
    function confirmBooking() {
        if (!selectedDate || !selectedTime) {
            showToast('Mohon pilih tanggal dan waktu', 'error');
            return;
        }
        // Redirect to confirmation page with date and time parameters
        const confirmUrl = `/booking/confirm/${courseId}/?date=${selectedDate}&time=${selectedTime}`;
        window.location.href = confirmUrl;
    }
</script>
````

## File: booking/templates/booking/confirmation.html
````html
{% extends 'base.html' %}
{% load static %}
{% block title %}Konfirmasi Booking - MamiCoach{% endblock %}
{% block content %}
<div class="bg-gradient-to-br from-green-50 to-blue-50 min-h-screen py-8">
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="mb-8">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-2">
                    <div class="w-8 h-8 rounded-full bg-emerald-600 text-white flex items-center justify-center text-sm font-semibold">
                        ✓
                    </div>
                    <span class="text-sm font-medium text-gray-700">Pilih Waktu</span>
                </div>
                <div class="flex-1 h-1 mx-4 bg-emerald-600"></div>
                <div class="flex items-center space-x-2">
                    <div class="w-8 h-8 rounded-full bg-emerald-600 text-white flex items-center justify-center text-sm font-semibold">
                        2
                    </div>
                    <span class="text-sm font-medium text-gray-900">Konfirmasi</span>
                </div>
                <div class="flex-1 h-1 mx-4 bg-gray-300"></div>
                <div class="flex items-center space-x-2">
                    <div class="w-8 h-8 rounded-full bg-gray-300 text-gray-600 flex items-center justify-center text-sm font-semibold">
                        3
                    </div>
                    <span class="text-sm font-medium text-gray-500">Pembayaran</span>
                </div>
            </div>
        </div>
        <div class="bg-white rounded-3xl shadow-xl overflow-hidden">
            <div class="bg-gradient-to-r from-emerald-600 to-green-600 p-6 text-white">
                <h1 class="text-2xl font-bold mb-2">Konfirmasi Booking</h1>
                <p class="text-emerald-50">Pastikan detail booking Anda sudah benar</p>
            </div>
            <div class="p-6 space-y-6">
                <div class="flex items-start space-x-4 p-4 bg-gradient-to-br from-green-50 to-blue-50 rounded-xl">
                    {% if course.thumbnail %}
                    <img
                        src="{{ course.thumbnail.url }}"
                        alt="{{ course.name }}"
                        class="w-20 h-20 rounded-lg object-cover"
                        onerror="this.src='{% static 'images/default-course.jpg' %}'"
                    >
                    {% else %}
                    <div class="w-20 h-20 bg-gray-200 rounded-lg flex items-center justify-center">
                        <svg class="w-10 h-10 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                        </svg>
                    </div>
                    {% endif %}
                    <div class="flex-1">
                        <h3 class="text-lg font-semibold text-gray-900">{{ course.name }}</h3>
                        <p class="text-sm text-gray-600">{{ course.description|truncatewords:10 }}</p>
                        <div class="flex items-center space-x-2 mt-2">
                            <svg class="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            <span class="text-sm text-gray-600">{{ course.duration }} menit</span>
                        </div>
                    </div>
                </div>
                <div class="border-t border-gray-200 pt-6">
                    <h3 class="text-sm font-semibold text-gray-500 uppercase tracking-wide mb-3">Coach</h3>
                    <div class="flex items-center space-x-4">
                        {% if course.coach.profile_picture %}
                        <img
                            src="{{ course.coach.profile_picture.url }}"
                            alt="{{ course.coach.user.get_full_name }}"
                            class="w-16 h-16 rounded-full object-cover"
                            onerror="this.src='{% static 'images/default-avatar.png' %}'"
                        >
                        {% else %}
                        <div class="w-16 h-16 bg-gray-300 rounded-full flex items-center justify-center">
                            <span class="text-gray-600 text-xl font-semibold">
                                {{ course.coach.user.first_name|first }}{{ course.coach.user.last_name|first }}
                            </span>
                        </div>
                        {% endif %}
                        <div>
                            <h4 class="font-semibold text-gray-900">{{ course.coach.user.get_full_name }}</h4>
                            {% if course.coach.rating %}
                            <div class="flex items-center space-x-1 mt-1">
                                <svg class="w-4 h-4 text-yellow-400 fill-current" viewBox="0 0 20 20">
                                    <path d="M10 15l-5.878 3.09 1.123-6.545L.489 6.91l6.572-.955L10 0l2.939 5.955 6.572.955-4.756 4.635 1.123 6.545z"/>
                                </svg>
                                <span class="text-sm font-medium text-gray-700">{{ course.coach.rating|floatformat:1 }}</span>
                            </div>
                            {% endif %}
                        </div>
                    </div>
                </div>
                <div class="border-t border-gray-200 pt-6">
                    <h3 class="text-sm font-semibold text-gray-500 uppercase tracking-wide mb-4">Jadwal Sesi</h3>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="p-4 bg-gradient-to-br from-emerald-50 to-emerald-100 rounded-xl border border-emerald-200">
                            <div class="flex items-center space-x-2 mb-2">
                                <svg class="w-5 h-5 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                </svg>
                                <span class="text-sm font-medium text-emerald-900">Tanggal</span>
                            </div>
                            <p class="text-lg font-bold text-emerald-900" id="displayDate">-</p>
                            <p class="text-sm text-emerald-700" id="displayDayName">-</p>
                        </div>
                        <div class="p-4 bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl border border-blue-200">
                            <div class="flex items-center space-x-2 mb-2">
                                <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                                <span class="text-sm font-medium text-blue-900">Waktu</span>
                            </div>
                            <p class="text-lg font-bold text-blue-900" id="displayTime">-</p>
                            <p class="text-sm text-blue-700">Durasi: {{ course.duration_formatted }}</p>
                        </div>
                    </div>
                </div>
                <div class="border-t border-gray-200 pt-6">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-gray-700">Harga per sesi</span>
                        <span class="text-lg font-semibold text-gray-900">{{ course.price_formatted }}</span>
                    </div>
                    <div class="flex items-center justify-between py-4 bg-gradient-to-r from-emerald-50 to-green-50 rounded-xl px-4 border border-emerald-200">
                        <span class="text-lg font-bold text-gray-900">Total Pembayaran</span>
                        <span class="text-2xl font-bold text-emerald-600">Rp {{ course.price|floatformat:0 }}</span>
                    </div>
                </div>
                <div class="bg-yellow-50 border border-yellow-200 rounded-xl p-4">
                    <div class="flex items-start space-x-3">
                        <svg class="w-5 h-5 text-yellow-600 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
                        </svg>
                        <div class="flex-1">
                            <h4 class="text-sm font-semibold text-yellow-900 mb-1">Penting!</h4>
                            <ul class="text-sm text-yellow-800 space-y-1">
                                <li>• Pastikan Anda hadir tepat waktu</li>
                                <li>• Booking akan menunggu konfirmasi dari coach</li>
                                <li>• Pembayaran akan diproses setelah konfirmasi</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="bg-gray-50 px-6 py-4 flex items-center justify-between">
                <a
                    href="{{ request.META.HTTP_REFERER|default:'/courses/'|add:course.id|add:'/' }}"
                    class="px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-100 transition-colors"
                >
                    ← Kembali
                </a>
                <button
                    type="button"
                    onclick="confirmBooking()"
                    id="confirmBtn"
                    class="px-8 py-3 bg-gradient-to-r from-emerald-600 to-green-600 text-white rounded-xl font-semibold hover:shadow-lg hover:from-emerald-700 hover:to-green-700 transition-all flex items-center space-x-2"
                >
                    <span>Lanjut ke Pembayaran</span>
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
                    </svg>
                </button>
            </div>
        </div>
        <div id="loadingOverlay" class="hidden fixed inset-0 bg-gray-900 bg-opacity-50 z-50 flex items-center justify-center">
            <div class="bg-white rounded-xl p-6 flex flex-col items-center">
                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-emerald-600 mb-4"></div>
                <p class="text-gray-700 font-medium">Memproses booking...</p>
            </div>
        </div>
    </div>
</div>
<script>
    // Get booking data from session storage or URL params
    const urlParams = new URLSearchParams(window.location.search);
    const bookingDate = urlParams.get('date');
    const bookingTime = urlParams.get('time');
    const courseId = {{ course.id }};
    // Display date and time
    function displayBookingInfo() {
        if (bookingDate && bookingTime) {
            // Format date
            const date = new Date(bookingDate);
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            const formattedDate = date.toLocaleDateString('id-ID', options);
            const dayName = date.toLocaleDateString('id-ID', { weekday: 'long' });
            document.getElementById('displayDate').textContent = date.toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' });
            document.getElementById('displayDayName').textContent = dayName;
            document.getElementById('displayTime').textContent = bookingTime;
        } else {
            // Show error toast and redirect to home
            showToast('Data booking tidak lengkap. Silakan coba lagi.', 'error');
            setTimeout(() => {
                window.location.href = '/';
            }, 1500);
        }
    }
    // Get CSRF token
    function getCookie(name) {
        let cookieValue = null;
        if (document.cookie && document.cookie !== '') {
            const cookies = document.cookie.split(';');
            for (let i = 0; i < cookies.length; i++) {
                const cookie = cookies[i].trim();
                if (cookie.substring(0, name.length + 1) === (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
    // Confirm booking
    async function confirmBooking() {
        if (!bookingDate || !bookingTime) {
            showToast('Data booking tidak lengkap. Silakan coba lagi.', 'error');
            return;
        }
        // Show loading
        document.getElementById('loadingOverlay').classList.remove('hidden');
        document.getElementById('confirmBtn').disabled = true;
        try {
            const response = await fetch(`/booking/api/course/${courseId}/create/`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': getCookie('csrftoken')
                },
                body: JSON.stringify({
                    date: bookingDate,
                    start_time: bookingTime
                })
            });
            const data = await response.json();
            if (!response.ok) {
                throw new Error(data.error || data.message || 'Gagal membuat booking');
            }
            if (data.success) {
                // Show success toast
                showToast('Booking berhasil dibuat! Redirecting...', 'success');
                // Redirect to payment page (to be implemented by payment team)
                // For now, redirect to success page or booking history
                setTimeout(() => {
                    window.location.href = `/booking/success/${data.booking_id}/`;
                }, 1500);
            }
        } catch (error) {
            console.error('Error:', error);
            showToast('Gagal membuat booking: ' + error.message, 'error');
            // Redirect back to course details after showing error
            setTimeout(() => {
                window.location.href = `/courses/${courseId}/`;
            }, 2000);
        } finally {
            document.getElementById('loadingOverlay').classList.add('hidden');
            document.getElementById('confirmBtn').disabled = false;
        }
    }
    // Initialize on page load
    document.addEventListener('DOMContentLoaded', displayBookingInfo);
</script>
{% endblock %}
````

## File: booking/templates/booking/success.html
````html
{% extends 'base.html' %}
{% load static %}
{% block meta %}
<title>Booking Berhasil - MamiCoach</title>
<script src="{% static 'js/toast.js' %}"></script>
{% endblock meta %}
{% block content %}
<div class="min-h-screen bg-gradient-to-br from-green-50 to-blue-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-3xl mx-auto">
        <div class="text-center mb-8">
            <div class="mx-auto flex items-center justify-center h-24 w-24 rounded-full bg-emerald-100 mb-4">
                <svg class="h-16 w-16 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                </svg>
            </div>
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Booking Berhasil!</h1>
            <p class="text-lg text-gray-600">ID Booking: #{{ booking.id }}</p>
        </div>
        <div class="bg-white shadow-lg rounded-lg overflow-hidden mb-6">
            <div class="bg-gradient-to-r from-emerald-600 to-green-600 px-6 py-4">
                <h2 class="text-xl font-semibold text-white">Detail Booking</h2>
            </div>
            <div class="p-6 space-y-6">
                <div class="flex items-start space-x-4">
                    {% if booking.course.thumbnail %}
                    <img src="{{ booking.course.thumbnail.url }}"
                         alt="{{ booking.course.name }}"
                         class="w-24 h-24 rounded-lg object-cover"
                         onerror="this.src='{% static 'images/default-course.jpg' %}'">
                    {% else %}
                    <div class="w-24 h-24 bg-gray-200 rounded-lg flex items-center justify-center">
                        <svg class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                        </svg>
                    </div>
                    {% endif %}
                    <div class="flex-1">
                        <h3 class="text-lg font-semibold text-gray-900">{{ booking.course.name }}</h3>
                        <p class="text-sm text-gray-600 mt-1">{{ booking.course.description|truncatewords:20 }}</p>
                        <div class="mt-2 flex items-center text-sm text-gray-500">
                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            {{ booking.course.duration }} menit
                        </div>
                    </div>
                </div>
                <div class="border-t pt-6">
                    <div class="flex items-center space-x-4 mb-6">
                        {% if booking.coach.profile_picture %}
                        <img src="{{ booking.coach.profile_picture.url }}"
                             alt="{{ booking.coach.user.get_full_name }}"
                             class="w-16 h-16 rounded-full object-cover"
                             onerror="this.src='{% static 'images/default-avatar.png' %}'">
                        {% else %}
                        <div class="w-16 h-16 bg-gray-300 rounded-full flex items-center justify-center">
                            <span class="text-gray-600 text-xl font-semibold">
                                {{ booking.coach.user.first_name|first }}{{ booking.coach.user.last_name|first }}
                            </span>
                        </div>
                        {% endif %}
                        <div>
                            <p class="text-sm text-gray-600">Coach</p>
                            <p class="font-semibold text-gray-900">{{ booking.coach.user.get_full_name }}</p>
                            {% if booking.coach.rating %}
                            <div class="flex items-center mt-1">
                                <svg class="w-4 h-4 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path>
                                </svg>
                                <span class="ml-1 text-sm text-gray-600">{{ booking.coach.rating }}</span>
                            </div>
                            {% endif %}
                        </div>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 bg-gradient-to-br from-green-50 to-blue-50 rounded-lg p-4">
                        <div>
                            <p class="text-sm text-gray-600 mb-1">Tanggal</p>
                            <p class="font-semibold text-gray-900">
                                {% if booking.start_datetime %}
                                {{ booking.start_datetime|date:"l, d F Y" }}
                                {% else %}
                                {{ booking.date|date:"l, d F Y" }}
                                {% endif %}
                            </p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600 mb-1">Waktu</p>
                            <p class="font-semibold text-gray-900">
                                {% if booking.start_datetime and booking.end_datetime %}
                                {{ booking.start_datetime|date:"H:i" }} - {{ booking.end_datetime|date:"H:i" }}
                                {% else %}
                                {{ booking.schedule.start_time }} - {{ booking.schedule.end_time }}
                                {% endif %}
                            </p>
                        </div>
                    </div>
                    <div class="mt-6 pt-6 border-t">
                        <div class="flex justify-between items-center mb-2">
                            <span class="text-gray-600">Harga Course</span>
                            <span class="font-semibold text-gray-900">Rp {{ booking.course.price|floatformat:0 }}</span>
                        </div>
                        <div class="flex justify-between items-center text-lg font-bold text-emerald-600 pt-2 border-t">
                            <span>Total Pembayaran</span>
                            <span>Rp {{ booking.course.price|floatformat:0 }}</span>
                        </div>
                    </div>
                    <div class="mt-6 pt-6 border-t">
                        <div class="flex items-center justify-between">
                            <span class="text-gray-600">Status Booking</span>
                            <span class="px-4 py-2 rounded-full text-sm font-semibold
                                {% if booking.status == 'pending' %}bg-yellow-100 text-yellow-800
                                {% elif booking.status == 'paid' %}bg-blue-100 text-blue-800
                                {% elif booking.status == 'confirmed' %}bg-green-100 text-green-800
                                {% elif booking.status == 'done' %}bg-gray-100 text-gray-800
                                {% else %}bg-red-100 text-red-800{% endif %}">
                                {{ booking.get_status_display }}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="bg-emerald-50 border border-emerald-200 rounded-lg p-6 mb-6">
            <h3 class="text-lg font-semibold text-emerald-900 mb-4 flex items-center">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
                Langkah Selanjutnya
            </h3>
            <ol class="space-y-3 text-gray-700">
                {% if booking.status == 'pending' %}
                <li class="flex items-start">
                    <span class="flex-shrink-0 w-6 h-6 bg-emerald-600 text-white rounded-full flex items-center justify-center text-sm font-semibold mr-3">1</span>
                    <span>Silakan lakukan pembayaran sebesar <strong>Rp {{ booking.course.price|floatformat:0 }}</strong></span>
                </li>
                <li class="flex items-start">
                    <span class="flex-shrink-0 w-6 h-6 bg-emerald-600 text-white rounded-full flex items-center justify-center text-sm font-semibold mr-3">2</span>
                    <span>Setelah pembayaran berhasil, status booking akan berubah menjadi "Paid"</span>
                </li>
                <li class="flex items-start">
                    <span class="flex-shrink-0 w-6 h-6 bg-emerald-600 text-white rounded-full flex items-center justify-center text-sm font-semibold mr-3">3</span>
                    <span>Coach akan mengkonfirmasi booking Anda</span>
                </li>
                <li class="flex items-start">
                    <span class="flex-shrink-0 w-6 h-6 bg-emerald-600 text-white rounded-full flex items-center justify-center text-sm font-semibold mr-3">4</span>
                    <span>Anda akan menerima notifikasi konfirmasi dan dapat memulai sesi</span>
                </li>
                {% elif booking.status == 'paid' %}
                <li class="flex items-start">
                    <span class="flex-shrink-0 w-6 h-6 bg-emerald-600 text-white rounded-full flex items-center justify-center text-sm">✓</span>
                    <span class="ml-3">Pembayaran berhasil!</span>
                </li>
                <li class="flex items-start">
                    <span class="flex-shrink-0 w-6 h-6 bg-emerald-600 text-white rounded-full flex items-center justify-center text-sm font-semibold mr-3">1</span>
                    <span>Menunggu konfirmasi dari coach</span>
                </li>
                <li class="flex items-start">
                    <span class="flex-shrink-0 w-6 h-6 bg-emerald-600 text-white rounded-full flex items-center justify-center text-sm font-semibold mr-3">2</span>
                    <span>Anda akan menerima notifikasi setelah coach mengkonfirmasi</span>
                </li>
                {% else %}
                <li class="flex items-start">
                    <span class="flex-shrink-0 w-6 h-6 bg-emerald-600 text-white rounded-full flex items-center justify-center text-sm">✓</span>
                    <span class="ml-3">Booking Anda sudah dikonfirmasi!</span>
                </li>
                <li class="flex items-start">
                    <span class="flex-shrink-0 w-6 h-6 bg-emerald-600 text-white rounded-full flex items-center justify-center text-sm font-semibold mr-3">1</span>
                    <span>Harap hadir tepat waktu pada jadwal yang sudah ditentukan</span>
                </li>
                {% endif %}
            </ol>
        </div>
        <div class="flex flex-col sm:flex-row gap-4 mt-8">
            {% if booking.status == 'pending' %}
            <button onclick="proceedToPayment({{ booking.id }})"
                class="flex-1 bg-gradient-to-r from-emerald-600 to-green-600 text-white py-4 rounded-2xl font-semibold text-center hover:shadow-lg hover:from-emerald-700 hover:to-green-700 transition-all duration-200 flex items-center justify-center space-x-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
                </svg>
                <span>Lanjut ke Pembayaran</span>
            </button>
            {% comment %} <a href="{% url 'payment:method_selection' booking_id=booking.id %}"
            class="flex-1 bg-primary text-white py-4 rounded-2xl font-semibold text-center hover:bg-green-600 transition-colors duration-200 flex items-center justify-center space-x-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
                </svg>
                <span>Lanjut ke Pembayaran</span>
            </a> {% endcomment %}
            <button onclick="showCancelConfirmation({{ booking.id }})"
                class="flex-1 border-2 border-red-300 text-red-600 py-4 rounded-2xl font-semibold text-center hover:bg-red-50 transition-colors duration-200">
                Batalkan Booking
            </button>
            {% endif %}
            <a href="/"
            class="flex-1 border-2 border-gray-300 text-gray-700 py-4 rounded-2xl font-semibold text-center hover:bg-gray-50 transition-colors duration-200">
                Kembali ke Beranda
            </a>
        </div>
        <div class="mt-6 bg-yellow-50 border border-yellow-200 rounded-lg p-4">
            <h4 class="font-semibold text-yellow-900 mb-2 flex items-center">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
                </svg>
                Catatan Penting
            </h4>
            <ul class="text-sm text-yellow-800 space-y-1 ml-7">
                <li>• Simpan ID booking (#{{ booking.id }}) untuk referensi</li>
                <li>• Pembatalan dapat dilakukan maksimal 24 jam sebelum jadwal</li>
                <li>• Hubungi customer service jika ada kendala</li>
            </ul>
        </div>
    </div>
</div>
<script>
function proceedToPayment(bookingId) {
    // TODO: Integrate with payment gateway
    // For now, just show alert
    //alert('Fitur pembayaran akan segera tersedia!\n\nBooking ID: ' + bookingId);
    window.location.href = `/payment/booking/${bookingId}/method`;
}
function showCancelConfirmation(bookingId) {
    document.getElementById('cancel-confirmation-modal').classList.remove('hidden');
    document.getElementById('cancel-confirmation-modal').dataset.bookingId = bookingId;
}
function closeCancelModal() {
    document.getElementById('cancel-confirmation-modal').classList.add('hidden');
}
function confirmCancelBooking() {
    const bookingId = document.getElementById('cancel-confirmation-modal').dataset.bookingId;
    fetch(`{% url 'booking:api_booking_cancel' booking_id=0 %}`.replace('0', bookingId), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRFToken': getCSRFToken()
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('Booking berhasil dibatalkan!', 'success');
            setTimeout(() => {
                window.location.href = "/";
            }, 1500);
        } else {
            showToast('Gagal membatalkan booking: ' + (data.message || 'Unknown error'), 'error');
            closeCancelModal();
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Terjadi kesalahan saat membatalkan booking', 'error');
        closeCancelModal();
    });
}
function getCSRFToken() {
    const name = 'csrftoken';
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}
// Close modal when clicking outside
document.addEventListener('click', function(e) {
    const modal = document.getElementById('cancel-confirmation-modal');
    if (e.target === modal) {
        closeCancelModal();
    }
});
</script>
<div id="cancel-confirmation-modal" class="hidden fixed inset-0 bg-black/50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-lg p-6 max-w-sm w-full mx-4">
        <h3 class="text-lg font-semibold text-gray-900 mb-2">Batalkan Booking?</h3>
        <p class="text-gray-600 mb-6">Apakah Anda yakin ingin membatalkan booking ini? Tindakan ini tidak dapat dibatalkan.</p>
        <div class="flex gap-3 justify-end">
            <button onclick="closeCancelModal()"
                    class="bg-gray-300 hover:bg-gray-400 text-gray-900 px-6 py-2 rounded-lg text-sm font-medium transition-colors">
                Tidak
            </button>
            <button onclick="confirmCancelBooking()"
                    class="bg-red-600 hover:bg-red-700 text-white px-6 py-2 rounded-lg text-sm font-medium transition-colors">
                Ya, Batalkan
            </button>
        </div>
    </div>
</div>
{% endblock content %}
````

## File: booking/admin.py
````python
@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin)
⋮----
list_display = ['id', 'user', 'coach', 'course', 'start_datetime', 'end_datetime', 'status', 'created_at']
list_filter = ['status', 'start_datetime', 'created_at']
search_fields = ['user__username', 'coach__user__username', 'course__title']
date_hierarchy = 'start_datetime'
ordering = ['-created_at']
readonly_fields = ['created_at', 'updated_at']
fieldsets = (
actions = ['mark_as_confirmed', 'mark_as_done', 'mark_as_canceled']
def mark_as_confirmed(self, request, queryset)
⋮----
def mark_as_done(self, request, queryset)
⋮----
def mark_as_canceled(self, request, queryset)
````

## File: booking/apps.py
````python
class BookingConfig(AppConfig)
⋮----
default_auto_field = 'django.db.models.BigAutoField'
name = 'booking'
````

## File: booking/forms.py
````python
class BookingForm(forms.ModelForm)
⋮----
class Meta
⋮----
model = Booking
fields = ['course', 'schedule', 'date']
widgets = {
labels = {
def __init__(self, *args, coach=None, **kwargs)
def clean(self)
⋮----
cleaned_data = super().clean()
schedule = cleaned_data.get('schedule')
course = cleaned_data.get('course')
date = cleaned_data.get('date')
⋮----
class BookingFilterForm(forms.Form)
⋮----
DAYS_OF_WEEK = [
STATUS_CHOICES = [
day = forms.ChoiceField(
status = forms.ChoiceField(
coach = forms.ModelChoiceField(
def __init__(self, *args, **kwargs)
````

## File: booking/models.py
````python
class Booking(models.Model)
⋮----
STATUS_CHOICES = [
user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='bookings')
coach = models.ForeignKey('user_profile.CoachProfile', on_delete=models.CASCADE, related_name='coach_bookings')
course = models.ForeignKey('courses_and_coach.Course', on_delete=models.CASCADE, related_name='course_bookings')
schedule = models.ForeignKey('schedule.ScheduleSlot', on_delete=models.CASCADE, null=True, blank=True)
date = models.DateField(null=True, blank=True)
start_datetime = models.DateTimeField(null=True, blank=True, help_text="Start date and time of the booking")
end_datetime = models.DateTimeField(null=True, blank=True, help_text="End date and time of the booking")
status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
created_at = models.DateTimeField(auto_now_add=True)
updated_at = models.DateTimeField(auto_now=True)
class Meta
⋮----
ordering = ['-created_at']
indexes = [
def clean(self)
def save(self, *args, **kwargs)
⋮----
old_instance = Booking.objects.filter(pk=self.pk).first()
⋮----
duration = self.end_datetime - self.start_datetime
minutes = int(duration.total_seconds() / 60)
⋮----
def __str__(self)
⋮----
@property
    def date(self)
⋮----
@property
    def start_time(self)
⋮----
@property
    def end_time(self)
````

## File: booking/urls.py
````python
app_name = 'booking'
urlpatterns = [
````

## File: booking/views.py
````python
@login_required(login_url="/login")
def get_available_dates(request, coach_id)
⋮----
coach = get_object_or_404(CoachProfile, id=coach_id)
year = int(request.GET.get('year', datetime.now().year))
month = int(request.GET.get('month', datetime.now().month))
schedule_slots = ScheduleSlot.objects.filter(
available_dates = []
⋮----
slots_count = ScheduleSlot.objects.filter(
booked_count = Booking.objects.filter(
⋮----
@login_required(login_url="/login")
def get_available_times(request, coach_id)
⋮----
date_str = request.GET.get('date')
⋮----
date = datetime.fromisoformat(date_str).date()
slots = ScheduleSlot.objects.filter(
available_times = []
⋮----
is_booked = Booking.objects.filter(
⋮----
@login_required(login_url="/login")
@require_POST
def create_booking(request, course_id)
⋮----
course = get_object_or_404(Course, id=course_id)
data = json.loads(request.body)
schedule_id = data.get('schedule_id')
date_str = data.get('date')
⋮----
schedule = get_object_or_404(ScheduleSlot, id=schedule_id)
⋮----
existing = Booking.objects.filter(
⋮----
booking = Booking.objects.create(
⋮----
@login_required(login_url="/login")
@require_http_methods(["GET"])
def api_course_start_times(request, course_id)
⋮----
target_date = datetime.strptime(date_str, '%Y-%m-%d').date()
⋮----
start_times = get_available_start_times(
⋮----
@login_required(login_url="/login")
@require_http_methods(["POST"])
def api_booking_create(request, course_id)
⋮----
start_time_str = data.get('start_time')
⋮----
coach = course.coach
naive_datetime = datetime.strptime(f"{date_str} {start_time_str}", "%Y-%m-%d %H:%M")
jakarta_tz = pytz.timezone('Asia/Jakarta')
start_datetime = jakarta_tz.localize(naive_datetime)
end_datetime = start_datetime + timedelta(minutes=course.duration)
⋮----
overlapping = Booking.objects.select_for_update().filter(
⋮----
@login_required(login_url="/login")
@require_http_methods(["GET"])
def api_booking_list(request)
⋮----
role = request.GET.get('role', 'user')
status_filter = request.GET.get('status')
⋮----
coach = CoachProfile.objects.get(user=request.user)
bookings_qs = Booking.objects.filter(coach=coach)
⋮----
bookings_qs = Booking.objects.filter(user=request.user)
⋮----
bookings_qs = bookings_qs.filter(status=status_filter)
bookings_qs = bookings_qs.select_related(
⋮----
def to_local(dt)
bookings_data = []
⋮----
start_local = to_local(booking.start_datetime)
end_local = to_local(booking.end_datetime)
created_local = to_local(booking.created_at)
⋮----
@login_required(login_url="/login")
@require_POST
def api_booking_update_status(request, booking_id)
⋮----
booking = get_object_or_404(Booking, id=booking_id)
⋮----
new_status = data.get('status')
⋮----
@login_required(login_url="/login")
@require_POST
def api_booking_cancel(request, booking_id)
⋮----
is_owner = booking.user == request.user
is_coach = False
⋮----
is_coach = booking.coach == coach
⋮----
@login_required(login_url="/login")
@require_POST
def api_booking_mark_as_paid(request, booking_id)
⋮----
data = json.loads(request.body) if request.body else {}
payment_id = data.get('payment_id')
payment_method = data.get('payment_method')
⋮----
@login_required(login_url="/login")
@require_http_methods(["GET"])
def api_coach_available_dates(request, coach_id)
⋮----
course_id = request.GET.get('course_id')
course = None
⋮----
course = get_object_or_404(Course, id=course_id, coach=coach)
⋮----
course = coach.courses.first()
⋮----
availabilities = CoachAvailability.objects.filter(
⋮----
include_date = True
available_times_count = None
⋮----
available_times_count = len(start_times)
include_date = available_times_count > 0
⋮----
payload = {
⋮----
@login_required(login_url="/login")
@require_http_methods(["GET"])
def api_coach_available_times(request, coach_id)
⋮----
@login_required(login_url="/login")
def booking_confirmation(request, course_id)
⋮----
booking_date = request.GET.get('date')
booking_time = request.GET.get('time')
context = {
⋮----
@login_required(login_url="/login")
def booking_success(request, booking_id)
⋮----
booking = get_object_or_404(Booking, id=booking_id, user=request.user)
````

## File: chat/migrations/0001_initial.py
````python
class Migration(migrations.Migration)
⋮----
initial = True
dependencies = [
operations = [
````

## File: chat/templates/pages/chat_interface.html
````html
{% extends "base_chat.html" %}
{% block title %}Chat{% endblock %}
{% block content %}
<div class="flex h-screen bg-gray-100 min-h-0">
    <div id="sessions-sidebar" class="w-full md:w-1/3 lg:w-1/4 bg-white border-r border-gray-200 flex flex-col {% if selected_session_id %}hidden md:flex{% endif %} min-h-0">
        <div class="flex-shrink-0 bg-primary text-white p-4">
            <div class="flex items-center justify-between">
                <h1 class="text-xl font-semibold">Chat</h1>
                <button id="search-toggle" class="p-2 hover:bg-white/10 rounded-lg transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                        <circle cx="11" cy="11" r="8"/>
                        <path d="m21 21-4.35-4.35"/>
                    </svg>
                </button>
            </div>
            <div id="search-container" class="mt-3 hidden">
                <div class="relative">
                    <input
                        type="text"
                        id="session-search"
                        placeholder="Cari percakapan..."
                        class="w-full bg-white/10 text-white placeholder-white/70 rounded-lg px-4 py-2 focus:outline-none focus:bg-white/20"
                    >
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 absolute right-3 top-3 text-white/70" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <circle cx="11" cy="11" r="8"/>
                        <path d="m21 21-4.35-4.35"/>
                    </svg>
                </div>
            </div>
        </div>
        <div class="flex-1 overflow-y-auto">
            <div id="sessions-loading" class="text-center py-8 text-gray-500">
                Memuat percakapan...
            </div>
            <div id="sessions-list" class="divide-y divide-gray-100">
            </div>
        </div>
    </div>
    <div id="chat-panel" class="flex-1 h-full flex flex-col {% if not selected_session_id %}hidden md:flex{% endif %} min-h-0">
        {% if selected_session_id %}
            <header class="bg-white border-b border-gray-200 px-4 py-3 flex-shrink-0 z-10">
                <div class="flex items-center">
                    <button id="back-to-sessions" class="md:hidden mr-3 p-2 hover:bg-gray-100 rounded-lg transition-colors">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                            <path d="m15 18-6-6 6-6"/>
                        </svg>
                    </button>
                    <div class="flex items-center space-x-3">
                        <div class="w-10 h-10 bg-primary text-white rounded-full flex items-center justify-center font-semibold">
                            {{ other_user.first_name.0|upper|default:"U" }}{{ other_user.last_name.0|upper|default:"" }}
                        </div>
                        <div>
                            <h2 class="font-semibold text-gray-900">
                                {{ other_user.first_name }} {{ other_user.last_name }}
                            </h2>
                        </div>
                    </div>
                </div>
            </header>
            <main id="messages-container" class="flex-1 overflow-y-auto p-4 bg-gray-50 min-h-0">
                <div id="messages-loading" class="text-center py-8 text-gray-500">
                    Memuat pesan...
                </div>
                <div id="messages-list">
                </div>
            </main>
            <footer class="bg-white border-t border-gray-200 p-4 flex-shrink-0 z-10">
                <div id="reply-context" class="mb-3 bg-blue-50 border-l-4 border-primary px-3 py-2 rounded hidden">
                    <div class="flex items-center justify-between">
                        <span class="text-sm text-gray-700">
                            <span class="font-semibold text-primary">Balas ke:</span>
                            <span id="reply-context-text" class="ml-2 text-gray-600 italic"></span>
                        </span>
                        <button type="button" id="clear-reply-btn" class="text-gray-400 hover:text-gray-600 transition-colors">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                                <path d="M18 6 6 18M6 6l12 12"/>
                            </svg>
                        </button>
                    </div>
                </div>
                <form id="message-form" class="flex items-end space-x-3 gap-2">
                    <div class="flex-1 flex flex-col items-center">
                        <textarea
                            id="message-input"
                            placeholder="Ketik pesan..."
                            rows="1"
                            class="w-full px-4 py-2 border border-gray-300 rounded-2xl focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent resize-none"
                        ></textarea>
                    </div>
                    <button
                        type="submit"
                        id="send-button"
                        disabled
                        class="bg-primary text-white p-3 rounded-full hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex-shrink-0 flex flex-col items-center justify-center"
                    >
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                            <path d="m22 2-7 20-4-9-9-4Z"/>
                            <path d="M22 2 11 13"/>
                        </svg>
                    </button>
                </form>
            </footer>
        {% else %}
            <div class="hidden md:flex flex-1 items-center justify-center bg-gray-50">
                <div class="text-center">
                    <div class="w-24 h-24 bg-gray-200 rounded-full flex items-center justify-center mx-auto mb-4">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-700 mb-2">Selamat datang di Chat MamiCoach</h3>
                    <p class="text-gray-500">Pilih percakapan untuk mulai chat</p>
                </div>
            </div>
        {% endif %}
    </div>
</div>
<script>
// Current chat session ID (from template context)
const selectedSessionId = {% if selected_session_id %}'{{ selected_session_id }}'{% else %}null{% endif %};
// Polling and window tracking
let pollInterval;
let isWindowActive = true;
let markReadTimeout;
let pendingMarkReadSessionId = null;
let currentReplyToMessageId = null;
let pendingAttachments = [];
// Local storage keys for tracking read status
const MARK_READ_KEY_PREFIX = 'chat_marked_read_';
/*
 * ============================================================================
 * INITIALIZATION & EVENT LISTENERS
 * ============================================================================
 */
function getLastMarkedReadTime(sessionId) {
    return localStorage.getItem(MARK_READ_KEY_PREFIX + sessionId);
}
function setLastMarkedReadTime(sessionId, timestamp) {
    localStorage.setItem(MARK_READ_KEY_PREFIX + sessionId, timestamp);
}
document.addEventListener('DOMContentLoaded', async function() {
    await loadSessions();
    // If we have a selected session, load its messages
    if (selectedSessionId) {
        await loadMessages(selectedSessionId);
        setupMessageInput();
        // Handle pre-attachment from presend route
        {% if pre_attachment %}
        addPreAttachmentToPending({
            type: '{{ pre_attachment.type }}',
            data: {{ pre_attachment.data|safe }}
        });
        {% endif %}
    }
    // Search functionality
    setupSearch();
    // Mobile navigation
    setupMobileNavigation();
    // Start polling for new conversations
    startPollingConversations();
    // Track window focus
    setupWindowFocusTracking();
});
// Track when window is active/inactive
function setupWindowFocusTracking() {
    window.addEventListener('focus', async function() {
        isWindowActive = true;
        // Refresh immediately when window regains focus
        await loadSessions();
        if (selectedSessionId) {
            await loadMessages(selectedSessionId, true);
        }
    });
    window.addEventListener('blur', function() {
        isWindowActive = false;
    });
}
// Helper to get CSRF token from cookie or DOM
function getCsrfToken() {
    // Try to get from DOM first (from {% csrf_token %})
    let csrftoken = document.querySelector('[name=csrfmiddlewaretoken]')?.value;
    // If not found, try to get from cookie
    if (!csrftoken) {
        csrftoken = document.cookie
            .split('; ')
            .find(row => row.startsWith('csrftoken='))
            ?.split('=')[1];
    }
    return csrftoken || '';
}
// Poll for new conversations every 3 seconds (only when window is active)
function startPollingConversations() {
    pollInterval = setInterval(async () => {
        if (isWindowActive) {
            await loadSessions();
        }
    }, 3000);
}
// Stop polling when page unloads
window.addEventListener('beforeunload', function() {
    if (pollInterval) {
        clearInterval(pollInterval);
    }
});
// Load and display sessions
async function loadSessions() {
    try {
        const response = await fetch('{% url "chat:get_chat_sessions" %}');
        const data = await response.json();
        const container = document.getElementById('sessions-list');
        const loading = document.getElementById('sessions-loading');
        if (loading) loading.style.display = 'none';
        if (data.sessions && data.sessions.length > 0) {
            container.innerHTML = data.sessions.map(createSessionItem).join('');
        } else {
            container.innerHTML = '<div class="text-center text-gray-500 py-8">Belum ada percakapan</div>';
        }
    } catch (error) {
        console.error('Error loading sessions:', error);
        const loading = document.getElementById('sessions-loading');
        if (loading) loading.textContent = 'Gagal memuat percakapan';
    }
}
// Helper function to format timestamp with date if yesterday or older
function formatMessageTime(timestamp) {
    const messageDate = new Date(timestamp);
    const today = new Date();
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);
    // Check if message is from today
    if (messageDate.toDateString() === today.toDateString()) {
        return messageDate.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
    }
    // Check if message is from yesterday
    if (messageDate.toDateString() === yesterday.toDateString()) {
        return 'Kemarin ' + messageDate.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
    }
    // For older messages, show date and time
    return messageDate.toLocaleDateString([], {month: 'short', day: 'numeric'}) + ' ' +
           messageDate.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
}
// Helper function to format file size
function formatFileSize(bytes) {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return (bytes / Math.pow(k, i)).toFixed(1) + ' ' + sizes[i];
}
// Helper function to create booking attachment HTML
function createBookingAttachmentHtml(attachment, isOwn) {
    // Defensive: always check for nested data
    const data = attachment.data || {};
    const courseId = attachment.course_id || data.course_id || '';
    const courseUrl = `{% url 'courses_and_coach:course_details' course_id='0' %}`.replace('/0', `/${courseId}`);
    // Normalize course title/name
    let courseTitle = attachment.course_title || attachment.course_name || data.course_title || data.course_name || data.title || 'Unknown Course';
    // Format booking date if present
    let bookingDate = attachment.booking_date || data.booking_date || '';
    if (bookingDate && bookingDate.length > 10) {
        try {
            const d = new Date(bookingDate);
            bookingDate = isNaN(d.getTime()) ? bookingDate : d.toLocaleString();
        } catch { /* ignore */ }
    }
    const bookingId = attachment.booking_id || attachment.id || data.booking_id || data.id || '';
    const status = attachment.status || data.status || '';
    return `
        <div class="mt-2 w-full max-w-sm bg-gradient-to-br from-blue-50 to-blue-100 ${isOwn ? 'from-white/20 to-white/10' : ''} rounded-lg p-3 border border-blue-200 ${isOwn ? 'border-white/20' : ''}">
            <div class="flex items-center gap-2 mb-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 ${isOwn ? 'text-white' : 'text-blue-600'}" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm3.5-9c.83 0 1.5-.67 1.5-1.5S16.33 8 15.5 8 14 8.67 14 9.5s.67 1.5 1.5 1.5zm-7 0c.83 0 1.5-.67 1.5-1.5S9.33 8 8.5 8 7 8.67 7 9.5 7.67 11 8.5 11zm3.5 6.5c2.33 0 4.31-1.46 5.11-3.5H6.89c.8 2.04 2.78 3.5 5.11 3.5z"/>
                </svg>
                <span class="font-semibold ${isOwn ? 'text-white' : 'text-blue-900'}">Booking</span>
            </div>
            <div class="space-y-1 text-sm">
                <p class="font-semibold ${isOwn ? 'text-white' : 'text-gray-800'}">Booking ID: ${DOMPurify.sanitize(String(bookingId))}</p>
                <p class="${isOwn ? 'text-white' : 'text-gray-800'}">Course: ${DOMPurify.sanitize(courseTitle)}</p>
                ${bookingDate ? `<p class="${isOwn ? 'text-white/80' : 'text-gray-600'}">Date: ${DOMPurify.sanitize(bookingDate)}</p>` : ''}
                ${status ? `<p class="${isOwn ? 'text-white/80' : 'text-gray-600'}">Status: ${DOMPurify.sanitize(status)}</p>` : ''}
                <a href="${courseUrl}" class="inline-block px-3 py-1 bg-blue-600 ${isOwn ? 'bg-white/30' : ''} text-white rounded hover:opacity-80 transition-opacity text-xs mt-2">View Course</a>
            </div>
        </div>
    `;
}
// Helper function to create course attachment HTML
function createCourseAttachmentHtml(attachment, isOwn) {
    const data = attachment.data || {};
    const courseId = attachment.course_id || data.course_id || '';
    const courseUrl = `{% url 'courses_and_coach:course_details' course_id='0' %}`.replace('/0', `/${courseId}`);
    // Normalize course title/name
    let courseTitle = attachment.course_title || attachment.course_name || data.title || data.course_title || data.course_name || 'Unknown Course';
    // Coach name
    let coachName = '';
    if (attachment.coach && (attachment.coach.first_name || attachment.coach.last_name)) {
        coachName = `${attachment.coach.first_name || ''} ${attachment.coach.last_name || ''}`.trim();
    } else if (data.coach && (data.coach.first_name || data.coach.last_name)) {
        coachName = `${data.coach.first_name || ''} ${data.coach.last_name || ''}`.trim();
    }
    // Location, price, duration
    const location = attachment.location || data.location || '';
    const price = attachment.price || data.price || '';
    const duration = attachment.duration || data.duration || '';
    return `
        <div class="mt-2 w-full max-w-sm bg-gradient-to-br from-purple-50 to-purple-100 ${isOwn ? 'from-white/20 to-white/10' : ''} rounded-lg p-3 border border-purple-200 ${isOwn ? 'border-white/20' : ''}">
            <div class="flex items-center gap-2 mb-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 ${isOwn ? 'text-white' : 'text-purple-600'}" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm0-13c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zm0 8c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3z"/>
                </svg>
                <span class="font-semibold ${isOwn ? 'text-white' : 'text-purple-900'}">Course</span>
            </div>
            <div class="space-y-1 text-sm">
                <p class="font-semibold ${isOwn ? 'text-white' : 'text-gray-800'}">${DOMPurify.sanitize(courseTitle)}</p>
                ${coachName ? `<p class="${isOwn ? 'text-white/80' : 'text-gray-600'}">Coach: ${DOMPurify.sanitize(coachName)}</p>` : ''}
                ${location ? `<p class="${isOwn ? 'text-white/80' : 'text-gray-600'}">Location: ${DOMPurify.sanitize(location)}</p>` : ''}
                ${price ? `<p class="${isOwn ? 'text-white/80' : 'text-gray-600'}">Price: Rp${DOMPurify.sanitize(String(price))}</p>` : ''}
                ${duration ? `<p class="${isOwn ? 'text-white/80' : 'text-gray-600'}">Duration: ${DOMPurify.sanitize(String(duration))} min</p>` : ''}
                <a href="${courseUrl}" class="inline-block px-3 py-1 bg-purple-600 ${isOwn ? 'bg-white/30' : ''} text-white rounded hover:opacity-80 transition-opacity text-xs mt-2">View Course</a>
            </div>
        </div>
    `;
}
function createSessionItem(session) {
    const isSelected = selectedSessionId === session.id;
    const lastMessageTime = session.last_message.timestamp ?
        formatMessageTime(session.last_message.timestamp) : '';
    const otherUserName = `${session.other_user.first_name} ${session.other_user.last_name}`.trim() || session.other_user.username;
    const userInitial = session.other_user.first_name ? session.other_user.first_name.charAt(0).toUpperCase() :
                        session.other_user.username.charAt(0).toUpperCase();
    return `
        <div class="session-item p-4 hover:bg-gray-50 cursor-pointer transition-colors ${isSelected ? 'bg-blue-50 border-r-4 border-primary' : ''}"
             data-session-id="${session.id}">
            <div class="flex items-start space-x-3">
                <div class="w-12 h-12 bg-primary text-white rounded-full flex items-center justify-center font-semibold flex-shrink-0">
                    ${userInitial}
                </div>
                <div class="flex-1 min-w-0">
                    <div class="flex justify-between items-start">
                        <h3 class="font-semibold text-gray-900 truncate">${DOMPurify.sanitize(otherUserName)}</h3>
                        <span class="text-xs text-gray-500 flex-shrink-0 ml-2">${lastMessageTime}</span>
                    </div>
                    <div class="flex justify-between items-center mt-1">
                        <p class="text-sm text-gray-600 truncate flex-1">
                            ${session.last_message.content ? DOMPurify.sanitize(session.last_message.content) : 'Belum ada pesan'}
                        </p>
                        ${session.unread_count > 0 ?
                            `<span class="bg-primary text-white text-xs font-semibold px-2 py-1 rounded-full flex-shrink-0 ml-2">${session.unread_count}</span>` : ''}
                    </div>
                </div>
            </div>
        </div>
    `;
}
// Handle session selection
document.addEventListener('click', function(e) {
    const sessionItem = e.target.closest('.session-item');
    if (sessionItem) {
        const sessionId = sessionItem.dataset.sessionId;
        // Navigate to the session URL
        window.location.href = `{% url 'chat:chat_detail' session_id='00000000-0000-0000-0000-000000000000' %}`.replace('00000000-0000-0000-0000-000000000000', sessionId);
    }
});
// Load messages for selected session
async function loadMessages(sessionId, skipScroll = false) {
    const container = document.getElementById('messages-list');
    const loading = document.getElementById('messages-loading');
    try {
        const response = await fetch(`{% url 'chat:get_messages' session_id='00000000-0000-0000-0000-000000000000' %}`.replace('00000000-0000-0000-0000-000000000000', sessionId));
        const data = await response.json();
        if (loading) loading.style.display = 'none';
        if (data.messages && data.messages.length > 0) {
            // On initial load, rebuild entire DOM
            container.innerHTML = data.messages.map(msg => createMessageItem({
                ...msg,
                is_sent_by_me: msg.sender.id === data.current_user_id
            })).join('');
        } else {
            container.innerHTML = '<div class="text-center text-gray-500 py-8">Belum ada pesan</div>';
        }
        // Setup scroll event listener for marking as read
        setupScrollToRead();
        // Debounced mark as read since we're viewing the messages
        debouncedMarkMessagesAsRead(sessionId);
    } catch (error) {
        console.error('Error loading messages:', error);
        if (loading) {
            loading.textContent = 'Gagal memuat pesan';
            loading.style.display = 'block';
        } else {
            container.innerHTML = '<div class="text-center text-red-500 py-8">Gagal memuat pesan</div>';
        }
    }
}
function createMessageItem(message) {
    const isOwn = message.is_sent_by_me;
    const messageTime = formatMessageTime(message.timestamp);
    // REPLY CONTEXT
    // Shows the original message being replied to
    let replyHtml = '';
    if (message.reply_to) {
        replyHtml = `
            <div class="bg-gray-100 ${isOwn ? 'bg-white/15' : ''} px-3 py-2 rounded-lg mb-3 border-l-4 border-secondary text-sm">
                <p class="font-semibold ${isOwn ? 'text-white/80' : 'text-primary'}">${DOMPurify.sanitize(message.reply_to.sender_username)}</p>
                <p class="${isOwn ? 'text-white/70' : 'text-gray-600'} truncate italic">${DOMPurify.sanitize(message.reply_to.content)}</p>
            </div>
        `;
    }
    // ATTACHMENTS RENDERING
    // Images: Show thumbnail preview (clickable for full size)
    // Files: Show download link with file size
    // Bookings/Courses: Show embed cards
    let attachmentsHtml = '';
    if (message.attachments && message.attachments.length > 0) {
        attachmentsHtml = '<div class="mt-2 space-y-2 flex flex-wrap gap-2">';
        message.attachments.forEach(att => {
            if (att.type === 'image' && att.file_url) {
                // IMAGE: Show thumbnail with click-to-expand
                attachmentsHtml += `
                    <div class="inline-block max-w-xs">
                        <a href="${att.file_url}" target="_blank" rel="noopener noreferrer">
                            <img src="${att.thumbnail_url || att.file_url}" alt="Image" class="w-full h-auto max-h-64 rounded-lg object-cover">
                        </a>
                    </div>
                `;
            } else if (att.type === 'booking' && att.booking_id) {
                // BOOKING: Show booking embed card
                attachmentsHtml += createBookingAttachmentHtml(att, isOwn);
            } else if (att.type === 'course' && att.course_id) {
                // COURSE: Show course embed card
                attachmentsHtml += createCourseAttachmentHtml(att, isOwn);
            } else if (att.file_url) {
                // FILE: Show as download link with metadata
                const fileSize = formatFileSize(att.file_size);
                attachmentsHtml += `
                    <div class="flex items-center gap-2 bg-gray-100 ${isOwn ? 'bg-white/20' : ''} p-2 rounded">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                            <path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/>
                            <polyline points="13 2 13 9 20 9"/>
                        </svg>
                        <a href="${att.file_url}" download="${att.file_name}" class="text-sm truncate ${isOwn ? 'text-white hover:underline' : 'text-primary hover:underline'}">
                            ${DOMPurify.sanitize(att.file_name)}
                        </a>
                        <span class="text-xs text-gray-500 flex-shrink-0">(${fileSize})</span>
                    </div>
                `;
            }
        });
        attachmentsHtml += '</div>';
    }
    return `
        <div class="mb-4 flex ${isOwn ? 'justify-end' : 'justify-start'} group" data-message-id="${message.id}">
            <div class="relative">
                <div class="max-w-xs lg:max-w-md ${isOwn ? 'bg-primary text-white' : 'bg-white text-gray-900'} rounded-2xl px-4 py-2 shadow-sm">
                    ${replyHtml}
                    <p class="break-words">${DOMPurify.sanitize(message.content)}</p>
                    ${attachmentsHtml}
                </div>
                <div class="flex ${isOwn ? 'justify-end' : 'justify-start'} mt-1 gap-2">
                    ${
                    isOwn?`
                        <button class="reply-btn opacity-100 md:opacity-0 md:group-hover:opacity-100 text-gray-500 hover:text-primary transition-opacity" data-message-id="${message.id}" title="Reply">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-reply-all"><path d="m12 17-5-5 5-5"/><path d="M22 18v-2a4 4 0 0 0-4-4H7"/><path d="m7 17-5-5 5-5"/></svg>
                        </button>`:''
                    }
                    <span class="text-xs text-gray-500 flex items-center">
                        ${messageTime}
                        ${isOwn ? (message.read ?
                            '<svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 ml-1 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" data-read-status><path d="M18 6 7 17l-5-5"/><path d="m22 10-7.5 7.5L13 16"/></svg>' :
                            '<svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" data-read-status><path d="M20 6 9 17l-5-5"/></svg>') : ''}
                    </span>
                    ${
                    !isOwn?`
                        <button class="reply-btn opacity-100 md:opacity-0 md:group-hover:opacity-100 text-gray-500 hover:text-primary transition-opacity" data-message-id="${message.id}" title="Reply">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-reply-all"><path d="m12 17-5-5 5-5"/><path d="M22 18v-2a4 4 0 0 0-4-4H7"/><path d="m7 17-5-5 5-5"/></svg>
                        </button>`:''
                    }
                </div>
            </div>
        </div>
    `;
}
function createMessageItemWithId(message) {
    return createMessageItem(message);
}
function setupMessageInput() {
    const messageInput = document.getElementById('message-input');
    const messageForm = document.getElementById('message-form');
    const sendButton = document.getElementById('send-button');
    // CREATE FILE INPUT for attachments
    // Hidden input, triggered by attachment button
    let fileInput = document.getElementById('chat-file-input');
    if (!fileInput) {
        fileInput = document.createElement('input');
        fileInput.type = 'file';
        fileInput.id = 'chat-file-input';
        fileInput.style.display = 'none';
        // Accepted file types: images, PDFs, Office documents
        fileInput.accept = 'image/*,.pdf,.doc,.docx,.xls,.xlsx,.txt';
        document.body.appendChild(fileInput);
        // When file selected, add to pending queue
        fileInput.addEventListener('change', async function(e) {
            if (this.files[0]) {
                await handleFileUpload(this.files[0]);
                this.value = '';  // Reset for next selection
            }
        });
    }
    // CREATE ATTACHMENT BUTTON
    // Appears in message input area next to send button
    // Click opens file picker
    let attachBtn = document.getElementById('attach-btn');
    if (!attachBtn && messageForm) {
        attachBtn = document.createElement('button');
        attachBtn.type = 'button';
        attachBtn.id = 'attach-btn';
        attachBtn.className = 'bg-gray-300 text-gray-700 p-3 rounded-full hover:bg-gray-400 focus:outline-none focus:ring-2 focus:ring-gray-500 transition-colors flex-shrink-0 flex items-center justify-center';
        attachBtn.title = 'Attach file';
        attachBtn.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path d="m21.44 11.05-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48"/></svg>`;
        // Button click opens file picker
        attachBtn.addEventListener('click', function(e) {
            e.preventDefault();
            fileInput.click();
        });
        // Insert button before send button
        messageForm.insertBefore(attachBtn, sendButton);
    }
    if (messageInput) {
        // ENABLE/DISABLE send button based on content or attachments
        messageInput.addEventListener('input', function() {
            sendButton.disabled = this.value.trim() === '' && pendingAttachments.length === 0;
            // Auto-resize textarea
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 120) + 'px';
        });
        messageInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                if (this.value.trim() || pendingAttachments.length > 0) {
                    sendMessage(selectedSessionId, currentReplyToMessageId);
                }
            }
        });
        sendButton.disabled = messageInput.value.trim() === '' && pendingAttachments.length === 0;
        messageInput.focus();
    }
    if (messageForm) {
        messageForm.addEventListener('submit', function(e) {
            e.preventDefault();
            if (messageInput.value.trim()) {
                sendMessage(selectedSessionId, currentReplyToMessageId);
            }
        });
    }
    // Setup reply button event delegation (works even for dynamically added messages)
    const messagesContainer = document.getElementById('messages-container');
    if (messagesContainer) {
        messagesContainer.addEventListener('click', function(e) {
            const replyBtn = e.target.closest('.reply-btn');
            if (replyBtn) {
                const messageId = replyBtn.dataset.messageId;
                currentReplyToMessageId = messageId;
                // Show reply context above textarea
                const messageElement = document.querySelector(`[data-message-id="${messageId}"]`);
                if (messageElement) {
                    // Get all paragraphs and find the message content (not in reply context)
                    const messageParagraphs = messageElement.querySelectorAll('.max-w-xs p, .max-w-md p');
                    const messageContent = messageParagraphs[0]?.textContent || 'message';
                    // Display reply context box
                    const replyContext = document.getElementById('reply-context');
                    const replyContextText = document.getElementById('reply-context-text');
                    if (replyContext && replyContextText) {
                        replyContextText.textContent = messageContent.substring(0, 60) + (messageContent.length > 60 ? '...' : '');
                        replyContext.classList.remove('hidden');
                    }
                    messageInput.focus();
                }
            }
        });
    }
    // Setup clear reply button
    const clearReplyBtn = document.getElementById('clear-reply-btn');
    if (clearReplyBtn) {
        clearReplyBtn.addEventListener('click', function(e) {
            e.preventDefault();
            clearReplyContext();
        });
    }
}
function clearReplyContext() {
    currentReplyToMessageId = null;
    const replyContext = document.getElementById('reply-context');
    if (replyContext) {
        replyContext.classList.add('hidden');
    }
}
/*
 * ============================================================================
 * ATTACHMENT UPLOAD FUNCTIONS
 * ============================================================================
 *
 * Multiple file attachment support allows users to:
 * 1. Select multiple files before sending
 * 2. See pending files in a preview list
 * 3. Remove files from queue before sending
 * 4. Upload all files to one message
 *
 * Key Features:
 * - Max 10MB per file
 * - Auto-detects image vs document
 * - Generates thumbnails for images
 * - Shows loading state before upload
 *
 * Flow:
 * File Select -> handleFileUpload() -> pendingAttachments[] updated
 *             -> updatePendingAttachmentsUI() displays list
 *             -> sendMessage() triggers uploadPendingAttachments()
 */
/*
 * Handles file selection from input element
 * Validates and adds file to pending queue
 *
 * @param {File} file - File object from file input
 */
async function handleFileUpload(file) {
    const MAX_FILE_SIZE = 3 * 1024 * 1024; // 10MB
    if (file.size > MAX_FILE_SIZE) {
        console.log(1)
        showToast('Ukuran file melebihi batas 3MB', 'error');
        return;
    }
    if (!selectedSessionId) {
        showToast('Silakan pilih percakapan terlebih dahulu', 'error');
        return;
    }
    try {
        // Add file to pending attachments queue
        // Type is auto-detected based on MIME type
        pendingAttachments.push({
            file: file,
            type: file.type.startsWith('image/') ? 'image' : 'file'
        });
        // Update UI to show pending attachment
        updatePendingAttachmentsUI();
    } catch (error) {
        console.error('Error preparing file:', error);
        showToast('Gagal menyiapkan file. Silakan coba lagi.', 'error');
    }
}
// Add pre-attachment from presend route to pending attachments
function addPreAttachmentToPending(preAttachment) {
    if (!preAttachment || !preAttachment.type || !preAttachment.data) {
        return;
    }
    // Add as a special attachment object (not a file)
    pendingAttachments.push({
        type: preAttachment.type,
        isEmbed: true,
        data: preAttachment.data
    });
    // Update UI to show pending attachment
    updatePendingAttachmentsUI();
}
function updatePendingAttachmentsUI() {
    let attachmentsList = document.getElementById('pending-attachments-list');
    // CREATE CONTAINER on first attachment
    if (!attachmentsList) {
        attachmentsList = document.createElement('div');
        attachmentsList.id = 'pending-attachments-list';
        attachmentsList.className = 'mt-2 mb-2 space-y-1 max-h-32 overflow-y-auto';
        const messageForm = document.getElementById('message-form');
        messageForm.parentNode.insertBefore(attachmentsList, messageForm);
    }
    // CLEAR if no attachments
    if (pendingAttachments.length === 0) {
        attachmentsList.innerHTML = '';
        return;
    }
    // RENDER each pending attachment with remove button
    attachmentsList.innerHTML = pendingAttachments.map((att, idx) => {
        if (att.isEmbed) {
            // Show booking/course embed preview
            if (att.type === 'booking') {
                return `
                    <div class="bg-blue-50 border border-blue-200 rounded p-2 flex items-center justify-between">
                        <div class="flex items-center gap-2 flex-1 min-w-0">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-blue-600 flex-shrink-0" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"/>
                            </svg>
                            <span class="text-sm text-gray-800 truncate">Booking: ${att.data.course_title}</span>
                        </div>
                        <button type="button" class="text-red-500 hover:text-red-700 font-bold flex-shrink-0 ml-2"
                                onclick="removePendingAttachment(${idx})">×</button>
                    </div>
                `;
            } else if (att.type === 'course') {
                return `
                    <div class="bg-purple-50 border border-purple-200 rounded p-2 flex items-center justify-between">
                        <div class="flex items-center gap-2 flex-1 min-w-0">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-purple-600 flex-shrink-0" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"/>
                            </svg>
                            <span class="text-sm text-gray-800 truncate">Course: ${att.data.title}</span>
                        </div>
                        <button type="button" class="text-red-500 hover:text-red-700 font-bold flex-shrink-0 ml-2"
                                onclick="removePendingAttachment(${idx})">×</button>
                    </div>
                `;
            }
        } else {
            // Show file attachment
            return `
                <div class="flex items-center gap-2 bg-gray-100 p-2 rounded text-sm">
                    <span class="flex-1 truncate">${att.file.name}</span>
                    <button type="button" class="text-red-500 hover:text-red-700 font-bold"
                            onclick="removePendingAttachment(${idx})">×</button>
                </div>
            `;
        }
    }).join('');
}
/*
 * Remove a specific file from the pending queue
 *
 * @param {number} index - Index in pendingAttachments array
 */
function removePendingAttachment(index) {
    pendingAttachments.splice(index, 1);
    updatePendingAttachmentsUI();
}
async function uploadPendingAttachments(messageId) {
    if (pendingAttachments.length === 0) {
        return;
    }
    try {
        // UPLOAD each file sequentially
        for (const attachment of pendingAttachments) {
            // Skip embeds - they're handled differently
            if (attachment.isEmbed) {
                continue;
            }
            const formData = new FormData();
            formData.append('file', attachment.file);
            formData.append('type', attachment.type);  // 'image' or 'file'
            formData.append('message_id', messageId);
            // SEND to upload endpoint
            const uploadResponse = await fetch(
                `{% url 'chat:upload_attachment' session_id='00000000-0000-0000-0000-000000000000' %}`
                    .replace('00000000-0000-0000-0000-000000000000', selectedSessionId),
                {
                    method: 'POST',
                    headers: {
                        'X-CSRFToken': getCsrfToken(),
                    },
                    body: formData
                }
            );
            const uploadData = await uploadResponse.json();
            // LOG errors but continue with other files
            if (!uploadData.success) {
                console.error('Error uploading attachment:', uploadData.error);
            }
        }
        // Clear pending attachments after upload
        pendingAttachments = [];
        const attachmentsList = document.getElementById('pending-attachments-list');
        if (attachmentsList) {
            attachmentsList.innerHTML = '';
        }
        // Reload messages to show uploaded files
        await loadMessages(selectedSessionId);
    } catch (error) {
        console.error('Error uploading attachments:', error);
        showToast('Gagal mengunggah beberapa file. Silakan coba lagi.', 'error');
    }
}
async function createEmbedAttachments(messageId) {
    if (pendingAttachments.length === 0) {
        return;
    }
    try {
        // CREATE embed attachments (bookings, courses, etc.)
        for (const attachment of pendingAttachments) {
            // Only process embeds
            if (!attachment.isEmbed) {
                continue;
            }
            const data = attachment.data || {};
            const attachmentData = {
                message_id: messageId,
                type: attachment.type,  // 'booking' or 'course'
            };
            // Add type-specific ID - check both direct and nested properties
            if (attachment.type === 'booking') {
                attachmentData.booking_id = attachment.booking_id || data.id || data.booking_id;
            } else if (attachment.type === 'course') {
                attachmentData.course_id = attachment.course_id || data.id || data.course_id;
            }
            // SEND to create attachment endpoint
            const createResponse = await fetch(
                `{% url 'chat:create_attachment' session_id='00000000-0000-0000-0000-000000000000' %}`
                    .replace('00000000-0000-0000-0000-000000000000', selectedSessionId),
                {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRFToken': getCsrfToken(),
                    },
                    body: JSON.stringify(attachmentData)
                }
            );
            const createData = await createResponse.json();
            console.log(attachment, attachmentData)
            console.log(createData)
            // LOG errors but continue with other embeds
            if (!createData.success) {
                console.error('Error creating embed attachment:', createData.error);
            }
        }
        // Clear pending attachments after creation
        pendingAttachments = [];
        const attachmentsList = document.getElementById('pending-attachments-list');
        if (attachmentsList) {
            attachmentsList.innerHTML = '';
        }
        // Reload messages to show created embeds
        await loadMessages(selectedSessionId);
    } catch (error) {
        console.error('Error creating embed attachments:', error);
        showToast('Error creating some attachments. Please try again.', 'error');
    }
}
async function sendMessage(sessionId, replyToId = null) {
    const messageInput = document.getElementById('message-input');
    const sendButton = document.getElementById('send-button');
    const content = messageInput.value.trim();
    // VALIDATION: Allow sending if there's text OR attachments
    if (!content && pendingAttachments.length === 0) return;
    messageInput.disabled = true;
    sendButton.disabled = true;
    try {
        const body = {
            session_id: sessionId,
            content: content || '(lampiran)'  // Allow sending just attachments
        };
        // ADD REPLY CONTEXT if replying to a message
        if (replyToId) {
            body.reply_to_id = replyToId;
        }
        // SEND THE TEXT MESSAGE
        const response = await fetch('{% url "chat:send_message" %}', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCsrfToken(),
            },
            body: JSON.stringify(body)
        });
        const data = await response.json();
        if (data.success) {
            const messageId = data.message.id;
            // UPLOAD FILE ATTACHMENTS if any are pending
            if (pendingAttachments.some(a => !a.isEmbed)) {
                await uploadPendingAttachments(messageId);
            }
            // CREATE EMBED ATTACHMENTS (bookings, courses) if any are pending
            if (pendingAttachments.some(a => a.isEmbed)) {
                await createEmbedAttachments(messageId);
            }
            messageInput.value = '';
            messageInput.style.height = 'auto';
            clearReplyContext();
            // Remove query parameters from URL
            if (window.history.replaceState) {
                const url = new URL(window.location);
                url.search = '';
                window.history.replaceState({}, '', url.toString());
            }
            // Always reload messages from server to avoid duplicates
            await loadMessages(selectedSessionId);
            // Refresh sessions to update last message and clear unread badges
            await loadSessions();
        } else {
            showToast('Gagal mengirim pesan: ' + (data.error || 'Kesalahan tidak diketahui'), 'error');
        }
    } catch (error) {
        console.error('Error sending message:', error);
        showToast('Gagal mengirim pesan. Silakan coba lagi.', 'error');
    } finally {
        messageInput.disabled = false;
        sendButton.disabled = (messageInput.value.trim() === '' && pendingAttachments.length === 0);
        messageInput.focus();
    }
}
async function markMessagesAsRead(sessionId) {
    try {
        await fetch('{% url "chat:mark_messages_read" %}', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCsrfToken(),
            },
            body: JSON.stringify({
                session_id: sessionId
            })
        });
    } catch (error) {
        console.error('Error marking messages as read:', error);
    }
}
// Debounced version of markMessagesAsRead to prevent spam
function debouncedMarkMessagesAsRead(sessionId) {
    // Clear existing timeout
    if (markReadTimeout) {
        clearTimeout(markReadTimeout);
    }
    // Store the session ID
    pendingMarkReadSessionId = sessionId;
    // Set a new timeout to mark as read after 1 second of inactivity
    markReadTimeout = setTimeout(() => {
        if (pendingMarkReadSessionId && isWindowActive) {
            const lastMarked = getLastMarkedReadTime(pendingMarkReadSessionId);
            const now = new Date().getTime();
            // Only call API if we haven't marked this session as read in the last 5 seconds
            if (!lastMarked || (now - parseInt(lastMarked)) > 5000) {
                markMessagesAsRead(pendingMarkReadSessionId);
                setLastMarkedReadTime(pendingMarkReadSessionId, now);
            }
            pendingMarkReadSessionId = null;
        }
    }, 1000);
}
function setupSearch() {
    const searchToggle = document.getElementById('search-toggle');
    const searchContainer = document.getElementById('search-container');
    const searchInput = document.getElementById('session-search');
    if (searchToggle) {
        searchToggle.addEventListener('click', function() {
            searchContainer.classList.toggle('hidden');
            if (!searchContainer.classList.contains('hidden')) {
                searchInput.focus();
            }
        });
    }
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            filterSessions(this.value.toLowerCase());
        });
    }
}
function filterSessions(query) {
    const sessionItems = document.querySelectorAll('.session-item');
    sessionItems.forEach(item => {
        const userName = item.querySelector('h3').textContent.toLowerCase();
        const lastMessage = item.querySelector('p').textContent.toLowerCase();
        if (userName.includes(query) || lastMessage.includes(query)) {
            item.style.display = 'block';
        } else {
            item.style.display = 'none';
        }
    });
}
function setupMobileNavigation() {
    const backButton = document.getElementById('back-to-sessions');
    const sessionsSidebar = document.getElementById('sessions-sidebar');
    const chatPanel = document.getElementById('chat-panel');
    if (backButton) {
        backButton.addEventListener('click', function() {
            // Navigate back to main chat page
            window.location.href = '{% url "chat:chat_index" %}';
        });
    }
}
function scrollToBottom() {
    const container = document.getElementById('messages-container');
    if (container) {
        // Use setTimeout to ensure DOM has fully rendered
        setTimeout(() => {
            container.scrollTop = container.scrollHeight;
        }, 0);
    }
}
function setupScrollToRead() {
    const messagesContainer = document.getElementById('messages-container');
    if (messagesContainer) {
        messagesContainer.addEventListener('scroll', function() {
            // Check if scrolled to bottom (within 100px)
            const isAtBottom = messagesContainer.scrollHeight - messagesContainer.scrollTop - messagesContainer.clientHeight < 100;
            if (isAtBottom && selectedSessionId) {
                // Debounced mark messages as read
                debouncedMarkMessagesAsRead(selectedSessionId);
            }
        });
    }
}
</script>
{% endblock %}
````

## File: chat/admin.py
````python
class ChatAttachmentInline(admin.TabularInline)
⋮----
model = ChatAttachment
extra = 0
readonly_fields = ('id', 'uploaded_at')
fields = ('attachment_type', 'file', 'file_name', 'file_size', 'uploaded_at')
class ChatMessageAdmin(admin.ModelAdmin)
⋮----
list_display = ('id', 'sender', 'session', 'timestamp', 'read')
list_filter = ('read', 'timestamp', 'session')
search_fields = ('content', 'sender__username')
readonly_fields = ('id', 'timestamp')
inlines = [ChatAttachmentInline]
class ChatSessionAdmin(admin.ModelAdmin)
⋮----
list_display = ('id', 'user', 'coach', 'started_at', 'last_message_at')
list_filter = ('started_at', 'last_message_at')
search_fields = ('user__username', 'coach__username')
readonly_fields = ('id', 'started_at', 'last_message_at')
class ChatAttachmentAdmin(admin.ModelAdmin)
⋮----
list_display = ('id', 'message', 'attachment_type', 'file_name', 'file_size', 'uploaded_at')
list_filter = ('attachment_type', 'uploaded_at')
search_fields = ('file_name', 'message__sender__username')
````

## File: chat/apps.py
````python
class ChatConfig(AppConfig)
⋮----
default_auto_field = 'django.db.models.BigAutoField'
name = 'chat'
````

## File: chat/models.py
````python
class ChatSession(models.Model)
⋮----
id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
user = models.ForeignKey(User, on_delete=models.CASCADE)
coach = models.ForeignKey(User, related_name='coach_sessions', on_delete=models.CASCADE)
started_at = models.DateTimeField(auto_now_add=True)
last_message_at = models.DateTimeField(auto_now=True)
ended_at = models.DateTimeField(null=True, blank=True)
class Meta
⋮----
ordering = ['-last_message_at']
unique_together = ('user', 'coach')
def __str__(self)
def get_other_user(self, current_user)
def get_last_message(self)
class ChatMessage(models.Model)
⋮----
session = models.ForeignKey(ChatSession, related_name='messages', on_delete=models.CASCADE)
sender = models.ForeignKey(User, on_delete=models.CASCADE)
content = models.TextField()
timestamp = models.DateTimeField(auto_now_add=True)
read = models.BooleanField(default=False)
reply_to = models.ForeignKey(
⋮----
ordering = ['timestamp']
⋮----
def is_sent_by(self, user)
class ChatAttachment(models.Model)
⋮----
ATTACHMENT_TYPE_CHOICES = [
⋮----
message = models.ForeignKey(ChatMessage, related_name='attachments', on_delete=models.CASCADE)
attachment_type = models.CharField(max_length=20, choices=ATTACHMENT_TYPE_CHOICES, default='file')
file = models.FileField(upload_to='chat_attachments/%Y/%m/%d/', null=True, blank=True)
thumbnail = models.ImageField(upload_to='chat_attachments/thumbnails/%Y/%m/%d/', null=True, blank=True)
uploaded_at = models.DateTimeField(auto_now_add=True)
course_id = models.IntegerField(null=True, blank=True)
course_name = models.CharField(max_length=255, null=True, blank=True)
booking_id = models.IntegerField(null=True, blank=True)
file_name = models.CharField(max_length=255, null=True, blank=True)
file_size = models.BigIntegerField(null=True, blank=True)
⋮----
ordering = ['uploaded_at']
````

## File: chat/urls.py
````python
app_name = "chat"
urlpatterns = [
````

## File: chat/views.py
````python
HAS_PIL = True
⋮----
HAS_PIL = False
⋮----
@login_required(login_url="/login")
def chat_index(request)
⋮----
@login_required(login_url="/login")
def chat_detail(request, session_id)
⋮----
session = get_object_or_404(ChatSession, id=session_id)
⋮----
context = {
pre_attachment_type = request.GET.get('pre_attachment_type')
pre_attachment_data = request.GET.get('pre_attachment_data')
⋮----
attachment_data = json_module.loads(pre_attachment_data)
⋮----
@login_required(login_url="/login")
def get_chat_sessions(request)
⋮----
is_coach = CoachProfile.objects.filter(user=request.user).exists()
⋮----
sessions = ChatSession.objects.filter(
⋮----
sessions_data = []
sessions_with_messages = []
⋮----
other_user = session.get_other_user(request.user)
last_message = ChatMessage.objects.filter(session=session).order_by('-timestamp').first()
unread_count = ChatMessage.objects.filter(
⋮----
session = item['session']
other_user = item['other_user']
last_message = item['last_message']
unread_count = item['unread_count']
⋮----
@login_required(login_url="/login")
def get_messages(request, session_id)
⋮----
messages = ChatMessage.objects.filter(session=session).order_by('timestamp')
messages_data = [
unread_messages = ChatMessage.objects.filter(
⋮----
@require_POST
@login_required(login_url="/login")
def send_message(request)
⋮----
data = json.loads(request.body)
session_id = data.get('session_id')
content = data.get('content', '').strip()
reply_to_id = data.get('reply_to_id')
⋮----
# Sanitize the message content
content = strip_tags(content)
# Verify content is not empty after sanitization
⋮----
# Check if user is part of this chat session
⋮----
# Handle reply_to if provided
reply_to = None
⋮----
reply_to = ChatMessage.objects.get(id=reply_to_id, session=session)
⋮----
# Create new message
message = ChatMessage.objects.create(
# Update session's last activity timestamp
⋮----
@require_POST
@login_required(login_url="/login")
def mark_messages_read(request)
⋮----
updated_count = unread_messages.update(read=True)
⋮----
@require_POST
@login_required(login_url="/login")
def create_chat_with_coach(request, coach_id)
⋮----
coach = get_object_or_404(User, id=coach_id)
⋮----
existing_session = ChatSession.objects.filter(
⋮----
session = ChatSession.objects.create(
⋮----
def _user_in_session(user, session)
def _serialize_message(message, is_current_user=None)
⋮----
attachments = [_serialize_attachment(att) for att in message.attachments.all()]
reply_data = None
⋮----
reply_data = {
⋮----
def _serialize_attachment(attachment)
⋮----
data = {
⋮----
course = Course.objects.get(id=attachment.course_id)
⋮----
booking = Booking.objects.get(id=attachment.booking_id)
⋮----
def _serialize_user(user)
⋮----
profile_image_url = None
⋮----
coach_profile = CoachProfile.objects.filter(user=user).first()
⋮----
profile_image_url = coach_profile.profile_image.url
⋮----
user_profile = UserProfile.objects.filter(user=user).first()
⋮----
profile_image_url = user_profile.profile_image.url
⋮----
@require_POST
@login_required(login_url="/login")
def upload_attachment(request, session_id)
⋮----
uploaded_file = request.FILES['file']
attachment_type = request.POST.get('type', 'file')
message_id = request.POST.get('message_id')
MAX_FILE_SIZE = 10 * 1024 * 1024
⋮----
message = ChatMessage.objects.get(id=message_id, session=session, sender=request.user)
⋮----
attachment = ChatAttachment.objects.create(
⋮----
img = Image.open(uploaded_file)
⋮----
thumb_io = BytesIO()
⋮----
thumbnail_name = f"thumb_{uploaded_file.name}"
⋮----
@require_POST
@login_required(login_url="/login")
def create_attachment(request, session_id)
⋮----
body = json.loads(request.body)
attachment_type = body.get('type')
message_id = body.get('message_id')
⋮----
attachment_data = {
⋮----
booking_id = body.get('booking_id')
⋮----
course_id = body.get('course_id')
⋮----
attachment = ChatAttachment.objects.create(**attachment_data)
⋮----
@login_required(login_url="/login")
def presend_booking(request, booking_id)
⋮----
booking = get_object_or_404(Booking, id=booking_id)
⋮----
session_id = existing_session.id
⋮----
session_id = session.id
booking_data = {
params = urlencode({
⋮----
@login_required(login_url="/login")
def presend_course(request, course_id)
⋮----
course = get_object_or_404(Course, id=course_id)
coach = course.coach
⋮----
next_url = request.GET.get('next', '/')
⋮----
# Check or create chat session
⋮----
# Create new session
⋮----
# Build redirect URL with pre-attachment data
course_data = {
````

## File: courses_and_coach/management/commands/__init__.py
````python
# Empty file to make this a Python package
````

## File: courses_and_coach/management/commands/populate_all.py
````python
class Command(BaseCommand)
⋮----
help = "Create sample data including categories, coaches, and courses"
def handle(self, *args, **options)
def create_trainees(self)
⋮----
trainee_data = [
⋮----
def create_reviews(self)
⋮----
review_contents = [
bookings = getattr(self, 'bookings_created', None)
⋮----
num_reviews = min(8, len(bookings))
sampled_bookings = random.sample(bookings, num_reviews)
⋮----
content = review_contents[i % len(review_contents)]
rating = random.randint(4, 5)
is_anonymous = random.choice([True, False])
review = Review.objects.create(
⋮----
def create_bookings(self)
⋮----
coach_usernames = [
users = list(User.objects.exclude(username__in=coach_usernames))
courses = list(Course.objects.all())
status_choices = [choice[0] for choice in Booking.STATUS_CHOICES]
⋮----
user = random.choice(users)
course = random.choice(courses)
coach = course.coach
start_datetime = timezone.now() + timezone.timedelta(days=random.randint(1, 30), hours=random.randint(6, 18))
duration_minutes = getattr(course, 'duration', random.choice([45, 60, 90]))
end_datetime = start_datetime + timezone.timedelta(minutes=duration_minutes)
status = random.choice(status_choices)
⋮----
def create_completed_bookings(self)
⋮----
# Create 5 completed bookings for each coach to seed their balance and hours
now = timezone.now()
completed_count = 0
⋮----
coach_courses = Course.objects.filter(coach=coach)
⋮----
# Create 3-5 completed bookings per coach
⋮----
course = random.choice(list(coach_courses))
duration_minutes = getattr(course, 'duration', 60)
# Create bookings in the past (2-30 days ago)
days_ago = random.randint(2, 30)
start_time = now - timezone.timedelta(days=days_ago, hours=random.randint(1, 10))
end_time = start_time + timezone.timedelta(minutes=duration_minutes)
# Create with pending status first, then transition to done
booking = Booking.objects.create(
# Transition to done to trigger hour and balance accumulation
⋮----
def create_categories(self)
⋮----
categories = [
⋮----
def create_coaches(self)
⋮----
coaches_data = [
⋮----
# Create user if doesn't exist
⋮----
def create_courses(self)
⋮----
courses_data = [
⋮----
# Yoga Courses
⋮----
# Pilates Courses
⋮----
# Strength Training Courses
⋮----
# Zumba Courses
⋮----
# Swimming Courses
⋮----
# Additional Yoga Courses
⋮----
# Additional Strength Training Courses
⋮----
# Additional Cardio Courses
⋮----
# Additional Pilates Courses
⋮----
# Additional Zumba Courses
⋮----
# Additional Swimming Courses
⋮----
courses = []
⋮----
# Get category and coach
⋮----
category = Category.objects.get(name=course_data["category"])
coach_user = User.objects.get(username=course_data["coach"])
coach_profile = CoachProfile.objects.get(user=coach_user)
````

## File: courses_and_coach/management/commands/seed_categories.py
````python
class Command(BaseCommand)
⋮----
help = "Seed categories with predefined thumbnails. Run this before crawling data."
def handle(self, *args, **options)
⋮----
categories_data = [
created_count = 0
updated_count = 0
````

## File: courses_and_coach/management/__init__.py
````python
# Empty file to make this a Python package
````

## File: courses_and_coach/migrations/0001_initial.py
````python
class Migration(migrations.Migration)
⋮----
initial = True
dependencies = [
operations = [
````

## File: courses_and_coach/templates/courses_and_coach/coaches/coach_details.html
````html
{% extends "base.html" %}
{% load static %}
{% block title %}{{ coach.user.get_full_name }} - MamiCoach{% endblock %}
{% block content %}
<div class=" min-h-screen">
    <div class="bg-primary sm:py-16">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex flex-col sm:flex-row items-center sm:items-start gap-6 sm:gap-8">
                <div class="flex-shrink-0">
                    <img
                        src="{{ coach.image_url }}"
                        alt="{{ coach.user.get_full_name }}"
                        class="w-32 h-32 sm:w-40 sm:h-40 rounded-full  object-center object-cover border-4 border-white shadow-xl"
                    >
                </div>
                <div class="text-center sm:text-left flex-1">
                    <h1 class="text-3xl sm:text-4xl font-bold text-white mb-2">{{ coach.user.get_full_name }}</h1>
                    <p class="text-lg sm:text-xl text-green-100 font-semibold mb-3">{{ coach.specialization }}</p>
                    {% if coach.bio %}
                    <p class="text-green-50 mb-4 text-sm sm:text-base leading-relaxed max-w-2xl">{{ coach.bio }}</p>
                    {% endif %}
                    {% if coach.expertise %}
                    <div class="mb-6">
                        <p class="text-green-100 text-sm font-semibold mb-2">Keahlian:</p>
                        <div class="flex flex-wrap justify-center sm:justify-start gap-2">
                            {% for skill in coach.expertise %}
                            <a
                                href="{% url 'courses_and_coach:category_detail' skill %}"
                                class="bg-white bg-opacity-20 hover:bg-opacity-30 text-primary font-semibold px-3 py-1 rounded-full text-sm font-medium transition-all duration-300 hover:shadow-lg"
                            >
                                {{ skill }}
                            </a>
                            {% endfor %}
                        </div>
                    </div>
                    {% endif %}
                    <div class="flex flex-wrap justify-center sm:justify-start gap-4 mt-6">
                        <div class="bg-white flex justify-center items-center gap-2 bg-opacity-20 rounded-lg px-2 py-1 backdrop-blur">
                            <p class="text-2xl font-bold text-black">{{ courses.count }}</p>
                            <p class="text-sm text-black">Kelas</p>
                        </div>
                        <div class="bg-white flex justify-center items-center gap-2 bg-opacity-20 rounded-lg px-2 py-1 backdrop-blur">
                            <p class="text-2xl font-bold text-black">{{ coach.total_hours_coached|floatformat:1 }}</p>
                            <p class="text-sm text-black">Jam Melatih</p>
                        </div>
                        {% if coach.rating %}
                        <div class="bg-white bg-opacity-20 rounded-lg px-4 py-2 backdrop-blur">
                            <div class="flex items-center gap-2">
                                <div class="flex items-center">
                                    {% with rating=coach.rating|floatformat:0|add:"0" %}
                                    {% for i in "12345" %}
                                        {% if forloop.counter <= rating %}
                                        <svg class="w-5 h-5 text-primary fill-current" viewBox="0 0 20 20">
                                            <path d="M10 15l-5.878 3.09 1.123-6.545L.489 6.91l6.572-.955L10 0l2.939 5.955 6.572.955-4.756 4.635 1.123 6.545z"></path>
                                        </svg>
                                        {% elif forloop.counter == rating|add:"1" and coach.rating|floatformat:1|slice:"2:" != "0" %}
                                        <svg class="w-5 h-5 text-primary fill-current" viewBox="0 0 20 20">
                                            <defs>
                                                <linearGradient id="half">
                                                    <stop offset="50%" stop-color="currentColor"/>
                                                    <stop offset="50%" stop-color="#E5E7EB"/>
                                                </linearGradient>
                                            </defs>
                                            <path d="M10 15l-5.878 3.09 1.123-6.545L.489 6.91l6.572-.955L10 0l2.939 5.955 6.572.955-4.756 4.635 1.123 6.545z" fill="url(#half)"></path>
                                        </svg>
                                        {% else %}
                                        <svg class="w-5 h-5 text-gray-300 fill-current" viewBox="0 0 20 20">
                                            <path d="M10 15l-5.878 3.09 1.123-6.545L.489 6.91l6.572-.955L10 0l2.939 5.955 6.572.955-4.756 4.635 1.123 6.545z"></path>
                                        </svg>
                                        {% endif %}
                                    {% endfor %}
                                    {% endwith %}
                                </div>
                                <span class="text-lg font-bold text-black">{{ coach.rating|floatformat:1 }}</span>
                            </div>
                        </div>
                        {% endif %}
                    </div>
                    <div class="mt-6">
                        <button
                            type="button"
                            onclick="startChatWithCoach({{ coach.user.id }})"
                            class="bg-white text-primary font-semibold px-6 py-3 rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-300 flex items-center gap-2"
                        >
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-message-circle">
                                <path d="M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719"/>
                            </svg>
                            Mulai Chat
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="mb-8">
            <div class="flex gap-2 border-b border-gray-200">
                <button
                    id="tab-courses"
                    class="tab-button active px-6 py-3 font-semibold text-gray-900 border-b-2 border-primary transition-all duration-300"
                    onclick="switchTab('courses')"
                >
                    Kelas dari Coach Ini
                </button>
                <button
                    id="tab-reviews"
                    class="tab-button px-6 py-3 font-semibold text-gray-600 border-b-2 border-transparent hover:text-gray-900 transition-all duration-300"
                    onclick="switchTab('reviews')"
                >
                    Ulasan
                </button>
            </div>
        </div>
        <div id="content-courses" class="tab-content">
            <div class="mb-12">
                <div class="flex items-center gap-3 mb-8">
                    <h2 class="text-3xl font-bold text-gray-900">Kelas dari Coach Ini</h2>
                    <span class="bg-primary text-white rounded-full px-4 py-1 font-semibold">{{ courses.count }}</span>
                </div>
                {% if courses %}
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {% for course in courses %}
                    {% include "courses_and_coach/partials/course_card.html" with course=course %}
                    {% endfor %}
                </div>
                {% else %}
                <div class="text-center py-12 bg-gray-50 rounded-3xl">
                    <svg class="w-16 h-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                    </svg>
                    <p class="text-gray-600 text-lg">Coach ini belum memiliki kelas.</p>
                </div>
                {% endif %}
            </div>
        </div>
        <div id="content-reviews" class="tab-content hidden">
            <div class="mb-12">
                <div class="flex items-center gap-3 mb-8">
                    <h2 class="text-3xl font-bold text-gray-900">Ulasan</h2>
                    <span class="bg-primary text-white rounded-full px-4 py-1 font-semibold">{{ coach.rating_count }}</span>
                </div>
                {% if coach_reviews %}
                <div class="space-y-6">
                    {% for review in coach_reviews %}
                    {% include "partials/_review_card.html" with review=review %}
                    {% endfor %}
                </div>
                {% else %}
                <div class="text-center py-12 bg-gray-50 rounded-3xl">
                    <svg class="w-16 h-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v12a2 2 0 01-2 2l-4 4z"></path>
                    </svg>
                    <p class="text-gray-600 text-lg">Belum ada ulasan untuk coach ini.</p>
                </div>
                {% endif %}
            </div>
        </div>
        <div class="text-center">
            <a
                href="{% url 'courses_and_coach:show_coaches' %}"
                class="inline-flex items-center gap-2 text-primary font-semibold hover:text-green-700 transition-colors duration-300"
            >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                </svg>
                Kembali ke Daftar Coach
            </a>
        </div>
    </div>
</div>
<script>
    function switchTab(tabName) {
        // Hide all tab contents
        const contents = document.querySelectorAll('.tab-content');
        contents.forEach(content => {
            content.classList.add('hidden');
        });
        // Show selected tab content
        const selectedContent = document.getElementById('content-' + tabName);
        if (selectedContent) {
            selectedContent.classList.remove('hidden');
        }
        // Update tab buttons styling
        const buttons = document.querySelectorAll('.tab-button');
        buttons.forEach(button => {
            button.classList.remove('border-primary', 'text-gray-900');
            button.classList.add('border-transparent', 'text-gray-600');
        });
        // Highlight active tab
        const activeButton = document.getElementById('tab-' + tabName);
        if (activeButton) {
            activeButton.classList.remove('border-transparent', 'text-gray-600');
            activeButton.classList.add('border-primary', 'text-gray-900');
        }
    }
    function startChatWithCoach(coachId) {
        const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]')?.value ||
                         document.cookie.split('; ').find(row => row.startsWith('csrftoken='))?.split('=')[1];
        fetch(`/chat/api/create-chat-with-coach/${coachId}/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': csrfToken
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast('Chat session started successfully', 'success');
                setTimeout(() => {
                    window.location.href = `/chat/${data.session_id}/`;
                }, 1000);
            } else {
                showToast(data.error || 'Failed to create chat session', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('An error occurred while creating chat session', 'error');
        });
    }
</script>
{% endblock %}
````

## File: courses_and_coach/templates/courses_and_coach/courses/confirm_delete.html
````html
{% extends 'base.html' %}
{% load static %}
{% block title %}Hapus Kelas - {{ course.title }}{% endblock %}
{% block content %}
<div class="max-w-3xl mx-auto py-12">
    <div class="bg-white rounded-2xl shadow p-6 text-center">
        <h1 class="text-2xl font-bold mb-4">Konfirmasi Hapus</h1>
        <p class="mb-6">Apakah Anda yakin ingin menghapus kelas "{{ course.title }}"? Tindakan ini tidak dapat dibatalkan.</p>
        <form method="post">
            {% csrf_token %}
            <div class="flex items-center justify-center gap-4">
                <button type="submit" class="bg-red-600 text-white px-6 py-2 rounded-lg">Hapus</button>
                <a href="{% url 'courses_and_coach:course_details' course.id %}" class="text-gray-600">Batal</a>
            </div>
        </form>
    </div>
</div>
{% endblock %}
````

## File: courses_and_coach/templates/courses_and_coach/courses/courses_details.html
````html
{% extends "base.html" %}
{% load static %}
{% block title %}{{ course.title }} - MamiCoach{% endblock %}
{% block content %}
<div class="bg-gray-50 min-h-screen">
    <div class="bg-white border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
            <nav class="flex" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-1 md:space-x-3">
                    <li class="inline-flex items-center">
                        <a href="{% url 'courses_and_coach:show_courses' %}" class="text-gray-500 hover:text-primary">Kelas</a>
                    </li>
                    <li>
                        <div class="flex items-center">
                            <svg class="w-5 h-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 111.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"></path>
                            </svg>
                            <a href="{% url 'courses_and_coach:category_detail' course.category.name %}" class="text-gray-500">{{ course.category.name }}</a>
                        </div>
                    </li>
                    <li>
                        <div class="flex items-center">
                            <svg class="w-5 h-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 111.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"></path>
                            </svg>
                            <span class="text-gray-900 font-medium">{{ course.title }}</span>
                        </div>
                    </li>
                </ol>
            </nav>
        </div>
    </div>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 relative">
            <div class="lg:col-span-2">
                <div class="relative rounded-3xl overflow-hidden shadow-xl mb-8">
                    <img
                        src="{{ course.thumbnail_url|default:'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80' }}"
                        alt="{{ course.title }}"
                        class="w-full h-96 object-cover"
                    >
                    <div class="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent"></div>
                    {% if course.coach.verified %}
                    <div class="absolute top-4 left-4 bg-primary text-white px-4 py-2 rounded-full text-sm font-medium flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <span>Verified Coach</span>
                    </div>
                    {% endif %}
                    <div class="absolute top-4 right-4 bg-white/90 backdrop-blur-sm text-gray-800 px-3 py-1 rounded-full text-sm font-medium">
                        {{ course.category.name }}
                    </div>
                </div>
                <div class="space-y-6">
                    <div >
                        {% if user.is_authenticated and user.coachprofile and user.coachprofile == course.coach %}
                        <div class="my-4 flex">
                            <a href="{% url 'courses_and_coach:edit_course' course.id %}" class="flex flex-row gap-1 leading-tight mr-2 px-4 py-2 bg-primary text-white rounded-lg font-medium hover:opacity-90">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-settings2-icon lucide-settings-2"><path d="M14 17H5"/><path d="M19 7h-9"/><circle cx="17" cy="17" r="3"/><circle cx="7" cy="7" r="3"/></svg>
                                Edit
                            </a>
                                <button type="button" id="delete-btn" class="flex flex-row justify-center items-center gap-1 leading-tight  px-4 py-2 bg-red-600 text-white rounded-lg font-medium hover:opacity-90 hover:cursor-pointer">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash2-icon lucide-trash-2"><path d="M10 11v6"/><path d="M14 11v6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M3 6h18"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                Hapus
                            </button>
                        </div>
                        {% endif %}
                        <h1 class="text-3xl sm:text-4xl font-bold text-gray-900 mb-4">
                            {{ course.title }}
                        </h1>
                        <div class="flex flex-col  space-y-2 text-sm text-gray-600">
                            <span class="flex items-center space-x-1">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                                <span>{{ course.duration_formatted }}</span>
                            </span>
                            <span class="flex items-center space-x-1">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                </svg>
                                <span>{{ course.created_at|date:"d M Y" }}</span>
                            </span>
                            <span class="flex items-center space-x-1">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                </svg>
                                <span>{{ course.location }}</span>
                            </span>
                        </div>
                    </div>
                    <div class="prose max-w-none">
                        <h3 class="text-xl font-semibold text-gray-900 mb-3">Tentang Kelas Ini</h3>
                        <p class="text-gray-600 leading-relaxed">{{ course.description }}</p>
                    </div>
                </div>
                {% if reviews %}
                <div class="mt-16">
                    <h2 class="text-2xl font-bold text-gray-900 mb-8">Ulasan dari Siswa</h2>
                    <div class="space-y-6">
                        {% for review in reviews %}
                            {% include 'partials/_review_card.html' with review=review %}
                        {% endfor %}
                    </div>
                </div>
                {% else %}
                <div class="mt-16">
                    <h2 class="text-2xl font-bold text-gray-900 mb-8">Ulasan dari Siswa</h2>
                    <div class="rounded-2xl bg-white p-12 text-center shadow-sm ring-1 ring-black/5">
                        <svg class="mx-auto h-12 w-12 text-neutral-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-1l-4 4z"></path>
                        </svg>
                        <h3 class="mt-4 text-lg font-semibold text-neutral-900">Belum ada ulasan</h3>
                        <p class="mt-2 text-neutral-600">Jadilah yang pertama memberi ulasan untuk kelas ini!</p>
                    </div>
                </div>
                {% endif %}
            </div>
            <div class="lg:col-span-1 mt-8 lg:mt-0">
                <div class="sticky top-24 h-fit">
                    {% include 'booking/booking_card.html' with course=course %}
                </div>
            </div>
        </div>
        {% if related_courses %}
        <div class="mt-16">
            <h2 class="text-2xl font-bold text-gray-900 mb-8">Kelas Serupa</h2>
            <div>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    {% for course in related_courses %}
                    {% include "courses_and_coach/partials/course_card.html" with course=course %}
                    {% endfor %}
                </div>
            </div>
        </div>
        {% endif %}
    </div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const deleteBtn = document.getElementById('delete-btn');
    if (!deleteBtn) return;
    // create modal
    const courseTitle = "{{ course.title|escapejs }}";
    const modal = document.createElement('div');
    modal.innerHTML = `
    <div id="confirm-delete-modal" class="fixed inset-0 bg-black/40 flex items-center justify-center z-50 hidden">
        <div class="bg-white rounded-lg p-6 max-w-md w-full">
            <h3 class="text-xl font-semibold mb-4">Konfirmasi Hapus</h3>
            <p class="mb-6">Apakah Anda yakin ingin menghapus kelas "${courseTitle}"? Tindakan ini tidak dapat dibatalkan.</p>
            <div class="flex justify-end gap-3">
                <button id="cancel-delete" class="px-4 py-2 hover:cursor-pointer rounded-md border">Batal</button>
                <button id="confirm-delete" class="px-4 py-2 hover:cursor-pointer bg-red-600 text-white rounded-md">Hapus</button>
            </div>
        </div>
    </div>`;
    document.body.appendChild(modal);
    const modalEl = document.getElementById('confirm-delete-modal');
    const cancelBtn = modalEl.querySelector('#cancel-delete');
    const confirmBtn = modalEl.querySelector('#confirm-delete');
    deleteBtn.addEventListener('click', function() {
        console.log("bruh");
        modalEl.classList.remove('hidden');
    });
    cancelBtn.addEventListener('click', function() {
        modalEl.classList.add('hidden');
    });
    confirmBtn.addEventListener('click', async function() {
        confirmBtn.disabled = true;
        try {
            const response = await fetch(`{% url 'courses_and_coach:delete_course' course.id %}`, {
                method: 'POST',
                headers: {
                    'X-CSRFToken': '{{ csrf_token }}',
                    'X-Requested-With': 'XMLHttpRequest',
                }
            });
            const data = await response.json();
            if (data.success && data.redirect) {
                window.location.href = data.redirect;
            } else {
                showToast('Gagal menghapus kelas.', 'error');
                modalEl.classList.add('hidden');
            }
        } catch (err) {
            console.error(err);
            showToast('Terjadi kesalahan. Silakan coba lagi.', 'error');
            modalEl.classList.add('hidden');
        } finally {
            confirmBtn.disabled = false;
        }
    });
});
</script>
{% endblock %}
````

## File: courses_and_coach/templates/courses_and_coach/courses/courses_list.html
````html
{% extends "base.html" %}
{% block title %}Courses - MamiCoach{% endblock %}
{% block content %}
    <h1>Courses</h1>
    <ul>
        <li>Course 1</li>
        <li>Course 2</li>
        <li>Course 3</li>
    </ul>
{% endblock %}
````

## File: courses_and_coach/templates/courses_and_coach/courses/create_course.html
````html
{% extends "base.html" %}
{% load static %}
{% block title %}Buat Kelas Baru - MamiCoach{% endblock %}
{% block content %}
<div class="bg-gray-50 min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-8">
            <div class="flex justify-center items-center space-x-4 mb-4">
                <h1 class="text-3xl sm:text-4xl font-bold text-gray-900">Buat Kelas Baru</h1>
                <a href="{% url 'courses_and_coach:my_courses' %}" class="bg-primary text-white font-bold px-2 py-1 rounded-xl hover:underline">Lihat Kelas</a>
            </div>
            <p class="text-lg text-gray-600">Bagikan keahlian Anda dan bantu lebih banyak orang mencapai tujuan fitness mereka</p>
        </div>
        <div class="bg-white rounded-3xl shadow-xl p-8">
            <style>
                .create-course-form ::placeholder {
                    color: #bcc1c9;
                    opacity: 1;
                }
                .create-course-form:-ms-input-placeholder { color: #374151; }
                .create-course-form::-ms-input-placeholder { color: #374151; }
            </style>
            <form method="post" class="space-y-6 create-course-form">
                {% csrf_token %}
                <div>
                    <label for="{{ form.title.id_for_label }}" class="block text-sm font-semibold text-gray-900 mb-2">
                        Nama Kelas *
                    </label>
                    {{ form.title }}
                    {% if form.title.errors %}
                        <p class="mt-1 text-sm text-red-600">{{ form.title.errors.0 }}</p>
                    {% endif %}
                </div>
                <div>
                    <label for="{{ form.category.id_for_label }}" class="block text-sm font-semibold text-gray-900 mb-2">
                        Kategori *
                    </label>
                    {{ form.category }}
                    {% if form.category.errors %}
                        <p class="mt-1 text-sm text-red-600">{{ form.category.errors.0 }}</p>
                    {% endif %}
                </div>
                <div>
                    <label for="{{ form.location.id_for_label }}" class="block text-sm font-semibold text-gray-900 mb-2">
                        Lokasi Kelas *
                    </label>
                    {{ form.location }}
                    {% if form.location.errors %}
                        <p class="mt-1 text-sm text-red-600">{{ form.location.errors.0 }}</p>
                    {% endif %}
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="{{ form.price.id_for_label }}" class="block text-sm font-semibold text-gray-900 mb-2">
                            Harga per Sesi (Rp) *
                        </label>
                        {{ form.price }}
                        {% if form.price.errors %}
                            <p class="mt-1 text-sm text-red-600">{{ form.price.errors.0 }}</p>
                        {% endif %}
                    </div>
                    <div>
                        <label for="{{ form.duration.id_for_label }}" class="block text-sm font-semibold text-gray-900 mb-2">
                            Durasi (Menit) *
                        </label>
                        {{ form.duration }}
                        {% if form.duration.errors %}
                            <p class="mt-1 text-sm text-red-600">{{ form.duration.errors.0 }}</p>
                        {% endif %}
                    </div>
                </div>
                <div>
                    <label for="{{ form.description.id_for_label }}" class="block text-sm font-semibold text-gray-900 mb-2">
                        Deskripsi Kelas *
                    </label>
                    {{ form.description }}
                    {% if form.description.errors %}
                        <p class="mt-1 text-sm text-red-600">{{ form.description.errors.0 }}</p>
                    {% endif %}
                    <p class="mt-1 text-sm text-gray-500">Jelaskan apa yang akan dipelajari peserta, level yang dibutuhkan, dan manfaat yang akan didapat.</p>
                </div>
                <div>
                    <label for="{{ form.thumbnail_url.id_for_label }}" class="block text-sm font-semibold text-gray-900 mb-2">
                        URL Gambar Kelas
                    </label>
                    {{ form.thumbnail_url }}
                    {% if form.thumbnail_url.errors %}
                        <p class="mt-1 text-sm text-red-600">{{ form.thumbnail_url.errors.0 }}</p>
                    {% endif %}
                    <p class="mt-1 text-sm text-gray-500">Opsional: Link ke gambar yang mewakili kelas Anda</p>
                </div>
                <div class="flex flex-col sm:flex-row gap-4 pt-6">
                    <button
                        type="submit"
                        class="flex-1 bg-primary text-white py-4 px-8 rounded-2xl font-semibold text-lg hover:bg-green-600 transition-colors duration-200 flex items-center justify-center space-x-2"
                    >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                        </svg>
                        <span>Buat Kelas</span>
                    </button>
                    <a
                        href="{% url 'courses_and_coach:my_courses' %}"
                        class="flex-1 sm:flex-none border-2 border-gray-300 text-gray-700 py-4 px-8 rounded-2xl font-semibold text-lg hover:border-primary hover:text-primary transition-colors duration-200 text-center"
                    >
                        Batal
                    </a>
                </div>
            </form>
        </div>
        <div class="mt-8 bg-white rounded-2xl shadow-lg p-6">
            <div class="flex items-start space-x-4">
                <div class="w-16 h-16 rounded-full overflow-hidden bg-gray-200">
                    <img
                        src="{{ coach_profile.image_url }}"
                        alt="{{ coach_profile.user.get_full_name }}"
                        class="w-full h-full object-cover"
                    >
                </div>
                <div class="flex-1">
                    <h3 class="font-semibold text-gray-900">{{ coach_profile.user.get_full_name }}</h3>
                    <p class="text-sm text-gray-600 mb-2">{{ coach_profile.expertise|join:", " }}</p>
                    <div class="flex items-center space-x-4 text-sm text-gray-500">
                        <span class="flex items-center space-x-1">
                            <svg class="w-4 h-4 text-yellow-400 fill-current" viewBox="0 0 20 20">
                                <path d="M10 15l-5.878 3.09 1.123-6.545L.489 6.91l6.572-.955L10 0l2.939 5.955 6.572.955-4.756 4.635 1.123 6.545z"/>
                            </svg>
                            <span>{{ coach_profile.rating|floatformat:1 }} Rating</span>
                        </span>
                        {% if coach_profile.verified %}
                        <span class="flex items-center space-x-1 text-primary">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            <span>Terverifikasi</span>
                        </span>
                        {% endif %}
                    </div>
                </div>
            </div>
        </div>
        <div class="mt-6 bg-blue-50 border border-blue-200 rounded-2xl p-6">
            <div class="flex items-start space-x-3">
                <svg class="w-6 h-6 text-blue-500 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
                <div>
                    <h4 class="font-semibold text-blue-900 mb-2">Tips Membuat Kelas yang Menarik:</h4>
                    <ul class="text-sm text-blue-800 space-y-1">
                        <li>• Gunakan nama kelas yang jelas dan mudah dipahami</li>
                        <li>• Tulis deskripsi yang detail tentang apa yang akan dipelajari</li>
                        <li>• Tentukan harga yang kompetitif sesuai dengan durasi dan level kelas</li>
                        <li>• Gunakan gambar yang menarik dan relevan dengan kelas Anda</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
{% endblock %}
````

## File: courses_and_coach/templates/courses_and_coach/courses/edit_course.html
````html
{% extends 'base.html' %}
{% load static %}
{% block title %}Edit Kelas - {{ course.title }}{% endblock %}
{% block content %}
<div class="max-w-3xl mx-auto py-12">
    <div class="bg-white rounded-2xl shadow p-6">
        <h1 class="text-2xl font-bold mb-4">Edit Kelas</h1>
        <form method="post">
            {% csrf_token %}
            {{ form.as_p }}
            <div class="flex items-center gap-4  mt-6">
                <button type="submit" class=" flex flex-row justify-center gap-1 leading-tight hover:cursor-pointer bg-primary text-white px-6 py-2 rounded-lg">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-save-icon lucide-save"><path d="M15.2 3a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z"/><path d="M17 21v-7a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7"/><path d="M7 3v4a1 1 0 0 0 1 1h7"/></svg>
                    Simpan Perubahan
                </button>
                <button type="button" id="delete-btn" class="flex flex-row justify-center items-center gap-1 leading-tight  px-4 py-2 bg-red-600 text-white rounded-lg font-medium hover:opacity-90 hover:cursor-pointer">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash2-icon lucide-trash-2"><path d="M10 11v6"/><path d="M14 11v6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M3 6h18"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                    Hapus
                </button>
                <a href="{% url 'courses_and_coach:course_details' course.id %}" class="text-gray-600">Batal</a>
            </div>
        </form>
    </div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const deleteBtn = document.getElementById('delete-btn');
    if (!deleteBtn) return;
    // create modal
    const courseTitle = "{{ course.title|escapejs }}";
    const modal = document.createElement('div');
    modal.innerHTML = `
    <div id="confirm-delete-modal" class="fixed inset-0 bg-black/40 flex items-center justify-center z-50 hidden">
        <div class="bg-white rounded-lg p-6 max-w-md w-full">
            <h3 class="text-xl font-semibold mb-4">Konfirmasi Hapus</h3>
            <p class="mb-6">Apakah Anda yakin ingin menghapus kelas "${courseTitle}"? Tindakan ini tidak dapat dibatalkan.</p>
            <div class="flex justify-end gap-3">
                <button id="cancel-delete" class="px-4 hover:cursor-pointer py-2 rounded-md border">Batal</button>
                <button id="confirm-delete" class="px-4  hover:cursor-pointer py-2 bg-red-600 text-white rounded-md">Hapus</button>
            </div>
        </div>
    </div>`;
    document.body.appendChild(modal);
    const modalEl = document.getElementById('confirm-delete-modal');
    const cancelBtn = modalEl.querySelector('#cancel-delete');
    const confirmBtn = modalEl.querySelector('#confirm-delete');
    deleteBtn.addEventListener('click', function() {
        modalEl.classList.remove('hidden');
    });
    cancelBtn.addEventListener('click', function() {
        modalEl.classList.add('hidden');
    });
    confirmBtn.addEventListener('click', async function() {
        confirmBtn.disabled = true;
        try {
            const response = await fetch(`{% url 'courses_and_coach:delete_course' course.id %}`, {
                method: 'POST',
                headers: {
                    'X-CSRFToken': '{{ csrf_token }}',
                    'X-Requested-With': 'XMLHttpRequest',
                }
            });
            const data = await response.json();
            if (data.success && data.redirect) {
                window.location.href = data.redirect;
            } else {
                showToast('Gagal menghapus kelas.', 'error');
                modalEl.classList.add('hidden');
            }
        } catch (err) {
            console.error(err);
            showToast('Terjadi kesalahan. Silakan coba lagi.', 'error');
            modalEl.classList.add('hidden');
        } finally {
            confirmBtn.disabled = false;
        }
    });
});
</script>
{% endblock %}
````

## File: courses_and_coach/templates/courses_and_coach/courses/my_courses.html
````html
{% extends "base.html" %}
{% load static %}
{% block title %}Kelas Saya - MamiCoach{% endblock %}
{% block content %}
<div class="bg-gray-50 min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 mb-2">Kelas Saya</h1>
                <p class="text-gray-600">Kelola semua kelas yang Anda buat</p>
            </div>
            <div class="flex items-center gap-3 mt-4 sm:mt-0">
                <button
                    onclick="openAvailabilityModal()"
                    class="inline-flex items-center space-x-2 bg-white border-2 border-primary text-primary px-6 py-3 rounded-2xl font-semibold hover:bg-primary hover:text-white transition-colors duration-200"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                    </svg>
                    <span>Atur Ketersediaan</span>
                </button>
                <a
                    href="{% url 'courses_and_coach:create_course' %}"
                    class="inline-flex items-center space-x-2 bg-primary text-white px-6 py-3 rounded-2xl font-semibold hover:bg-green-600 transition-colors duration-200"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                    </svg>
                    <span>Buat Kelas Baru</span>
                </a>
            </div>
        </div>
        {% if courses %}
        <div class="bg-white rounded-3xl shadow-xl overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200">
                <h2 class="text-xl font-semibold text-gray-900">Daftar Kelas</h2>
            </div>
            <div class="divide-y divide-gray-200">
                {% for course in courses %}
                <div class="p-4 sm:p-6 hover:bg-gray-50 transition-colors duration-200">
                    <div class="flex flex-col sm:flex-row sm:items-center sm:space-x-4">
                        <div class="flex-shrink-0 self-center sm:self-start">
                            <img
                                src="{{ course.thumbnail_url|default:'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80' }}"
                                alt="{{ course.title }}"
                                class="w-full h-full sm:w-24 sm:h-24 rounded-xl object-cover"
                            >
                        </div>
                        <div class="flex-1 mt-3 sm:mt-0 min-w-0">
                            <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between">
                                <div class="pr-2">
                                    <h3 class="text-base sm:text-lg font-semibold text-gray-900 truncate">{{ course.title }}</h3>
                                    <p class="text-sm text-gray-500 mt-1 truncate">{{ course.category.name }}</p>
                                    <div class="flex flex-wrap items-center gap-3 mt-2 text-sm text-gray-600">
                                        <span class="flex items-center space-x-1">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                            </svg>
                                            <span class="truncate">{{ course.duration_formatted }}</span>
                                        </span>
                                        <span class="flex items-center space-x-1 max-w-xs">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path>
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                            </svg>
                                            <span class="truncate">{{ course.location }}</span>
                                        </span>
                                        <span class="flex items-center space-x-1">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                            </svg>
                                            <span>{{ course.created_at|date:"d M Y" }}</span>
                                        </span>
                                    </div>
                                </div>
                                <div class="mt-3 sm:mt-0 sm:text-right flex-shrink-0">
                                    <p class="text-lg sm:text-xl font-bold text-primary">{{ course.price_formatted }}</p>
                                    <p class="text-sm text-gray-500">per sesi</p>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4 sm:mt-0 sm:ml-4 flex flex-col sm:flex-row items-stretch sm:items-center sm:space-x-2 space-y-2 sm:space-y-0 w-full sm:w-auto">
                            <a
                                href="{% url 'courses_and_coach:course_details' course.id %}"
                                class="inline-flex justify-center items-center px-4 py-2 border border-gray-300 rounded-2xl text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 transition-colors duration-200 w-full sm:w-auto"
                            >
                                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                                </svg>
                                Lihat
                            </a>
                            <a href="{% url 'courses_and_coach:edit_course' course.id %}" class="w-full sm:w-auto">
                                <button type="button" class="inline-flex justify-center cursor-pointer items-center w-full sm:w-auto px-4 py-2 border border-primary text-primary rounded-2xl text-sm font-medium hover:bg-primary hover:text-white transition-colors duration-200">
                                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                                    </svg>
                                    Edit
                                </button>
                            </a>
                        </div>
                    </div>
                </div>
                {% endfor %}
            </div>
        </div>
        {% else %}
        <div class="text-center py-16">
            <div class="max-w-md mx-auto">
                <svg class="w-24 h-24 mx-auto text-gray-400 mb-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                </svg>
                <h3 class="text-xl font-semibold text-gray-900 mb-2">Belum Ada Kelas</h3>
                <p class="text-gray-600 mb-6">Mulai bagikan keahlian Anda dengan membuat kelas pertama</p>
                <a
                    href="{% url 'courses_and_coach:create_course' %}"
                    class="inline-flex items-center space-x-2 bg-primary text-white px-6 py-3 rounded-2xl font-semibold hover:bg-green-600 transition-colors duration-200"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                    </svg>
                    <span>Buat Kelas Pertama</span>
                </a>
            </div>
        </div>
        {% endif %}
    </div>
</div>
{% include 'schedule/_availability_modal.html' with today=today %}
<script src="{% static 'js/schedule-availability.js' %}"></script>
{% endblock %}
````

## File: courses_and_coach/templates/courses_and_coach/partials/coach_card.html
````html
<a
    href="{% url 'courses_and_coach:coach_details' coach.id %}"
    class="coach-card group"
>
    <div class="relative overflow-hidden rounded-3xl bg-white shadow-lg hover:shadow-2xl transition-all duration-500 h-full hover:-translate-y-2">
        <div class="relative h-56 overflow-hidden bg-gradient-to-br from-primary/20 to-secondary/20">
            <img
                src="{{ coach.image_url }}"
                alt="{{ coach.user.get_full_name|default:coach.user.username }}"
                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
            />
            <div class="absolute inset-0  group-hover:opacity-60 transition-opacity duration-300"></div>
            <div class="absolute inset-0 flex items-end justify-between p-3">
                {% if coach.verified %}
                <div class="bg-white rounded-full p-1.5 shadow-lg">
                    <svg class="w-4 h-4 text-primary" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"></path>
                    </svg>
                </div>
                {% endif %}
                <div class="bg-white/95 backdrop-blur-sm rounded-full px-2.5 py-1 flex items-center gap-1 shadow-lg">
                    <svg class="w-4 h-4 text-yellow-400 fill-current" viewBox="0 0 20 20">
                        <path d="M10 15l-5.878 3.09 1.123-6.545L.489 6.91l6.572-.955L10 0l2.939 5.955 6.572.955-4.756 4.635 1.123 6.545z"></path>
                    </svg>
                    <span class="font-bold text-gray-900 text-sm">  {{ coach.rating|default:0|floatformat:1 }} ({{ coach.rating_count }})</span>
                </div>
            </div>
        </div>
        <div class="p-5 space-y-3">
            <div>
                <h3 class="text-lg font-bold text-gray-900 group-hover:text-primary transition-colors duration-300 truncate">
                    {{ coach.user.get_full_name|default:coach.user.username }}
                </h3>
                <p class="text-xs text-gray-500 truncate">@{{ coach.user.username }}</p>
            </div>
            {% if coach.bio %}
            <p class="text-gray-600 text-xs line-clamp-1 leading-relaxed">
                {{ coach.bio }}
            </p>
            {% endif %}
            {% if coach.expertise %}
            <div class="flex flex-wrap gap-1">
                {% for skill in coach.expertise|slice:":2" %}
                <span class="inline-block bg-primary/10 text-primary text-xs px-2 py-0.5 rounded-full font-medium truncate">
                    {{ skill }}
                </span>
                {% endfor %}
                {% if coach.expertise|length > 2 %}
                <span class="inline-block bg-gray-100 text-gray-600 text-xs px-2 py-0.5 rounded-full font-medium">
                    +{{ coach.expertise|length|add:"-2" }}
                </span>
                {% endif %}
            </div>
            {% endif %}
            <button class="w-full bg-gradient-to-r from-primary to-green-600 hover:from-green-600 hover:to-primary text-white py-2 rounded-xl font-semibold text-sm transition-all duration-300 transform group-hover:scale-105 mt-2">
                Lihat Detail
            </button>
        </div>
    </div>
</a>
````

## File: courses_and_coach/templates/courses_and_coach/partials/course_card.html
````html
{% load static %}
<div class="bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300 group">
    <a href="{% url 'courses_and_coach:course_details' course.id %}">
        <div>
            <img
                src="{{ course.thumbnail_url|default:'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80' }}"
                alt="{{ course.title }}"
                class="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
            >
        </div>
    </a>
    <div class="p-4">
        <div class="flex justify-between items-center mb-2">
            {% if course.coach.verified %}
            <div class="bg-primary/10 text-primary px-3 py-1 rounded-full text-xs font-medium flex items-center space-x-1">
                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
                <span>Verified Coach</span>
            </div>
            {% endif %}
            <a href="{% url 'courses_and_coach:category_detail' course.category.name %}"
               class="bg-gray-100 text-gray-800 px-2 py-1 rounded-lg text-xs font-medium hover:bg-gray-200 hover:shadow-sm transition-all duration-200">
                {{ course.category.name }}
            </a>
        </div>
        <a href="{% url 'courses_and_coach:course_details' course.id %}">
            <h3 class="font-bold text-gray-900 mb-2 line-clamp-2 group-hover:text-primary transition-colors duration-200">
                {{ course.title }}
            </h3>
        </a>
        <div class="flex items-center space-x-2 mb-3">
            <div class="w-8 h-8 rounded-full overflow-hidden bg-gray-200">
                <img
                    src="{{course.coach.image_url}}"
                    class="w-full h-full object-cover"
                >
            </div>
            <div>
                <p class="text-sm font-medium text-gray-900">{{ course.coach.user.get_full_name }}</p>
                <p class="text-xs text-gray-500">{{ course.category.name }}</p>
            </div>
        </div>
        <div class="space-y-2 mb-4">
            <div class="flex items-center text-sm text-gray-600">
                <svg class="w-4 h-4 mr-2" fill="none"  viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
                <span>{{ course.duration_formatted }}</span>
            </div>
            <div class="flex items-center text-sm text-primary">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-map-pin-icon lucide-map-pin"><path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/><circle cx="12" cy="10" r="3"/></svg>
                <span class="truncate">{{ course.location }}</span>
            </div>
            <div class="flex items-center text-sm text-gray-600">
                <svg class="w-4 h-4 mr-2 text-primary fill-current" viewBox="0 0 20 20">
                    <path d="M10 15l-5.878 3.09 1.123-6.545L.489 6.91l6.572-.955L10 0l2.939 5.955 6.572.955-4.756 4.635 1.123 6.545z"/>
                </svg>
                <span>{{ course.coach.rating|floatformat:1 }} ({{course.coach.rating_count}})</span>
            </div>
        </div>
        <div class="flex items-center justify-between pt-4 border-t border-gray-100">
            <div>
                <span class="text-xl font-bold text-primary">{{ course.price_formatted }}</span>
                <span class="text-sm text-gray-500">/sesi</span>
            </div>
            <a href="{% url 'courses_and_coach:course_details' course.id %}">
            <div class="bg-primary text-white px-4 py-2 rounded-xl text-sm font-medium hover:bg-green-600 transition-colors duration-200 whitespace-nowrap">
                Details&nbsp;>
            </div>
        </a>
        </div>
    </div>
</div>
````

## File: courses_and_coach/templates/courses_and_coach/category_detail.html
````html
{% extends 'base.html' %}
{% load static %}
{% block title %}{{ category.name }} - MamiCoach{% endblock %}
{% block content %}
<div class="min-h-screen">
    <div class="relative bg-primary text-white">
        <div class="absolute inset-0"></div>
        <div class="relative container mx-auto px-16 py-16">
            <div class="flex flex-col-reverse md:flex-row gap-8 items-center justify-around">
                <div>
                    <h1 class="text-4xl font-bold mb-4">{{ category.name }}</h1>
                    <p class="text-xl text-pink-100 mb-6">{{ category.description }}</p>
                    <div class="flex items-center space-x-4">
                        <span class="bg-white bg-opacity-20 backdrop-blur-sm px-4 py-2 rounded-full text-primary font-bold  text-sm">
                            {{ courses.paginator.count }} kelas tersedia
                        </span>
                    </div>
                </div>
                {% if category.thumbnail_url %}
                <div class="">
                    <img
                        src="{{ category.thumbnail_url }}"
                        alt="{{ category.name }}"
                        class="w-full h-64 object-cover rounded-lg"
                    >
                </div>
                {% endif %}
            </div>
        </div>
    </div>
    <div class="container mx-auto px-12 py-8">
        <div class="flex gap-4 mb-8 border-b border-gray-200">
            <button id="courses-tab" class="tab-button active px-4 py-3 font-semibold text-primary border-b-2 border-primary transition-colors" onclick="switchTab('courses')">
                Kelas ({{ courses_count|default:0 }})
            </button>
            <button id="coaches-tab" class="tab-button px-4 py-3 font-semibold text-gray-600 border-b-2 border-transparent hover:text-gray-900 transition-colors" onclick="switchTab('coaches')">
                Coach ({{ coaches_count|default:0 }})
            </button>
        </div>
        <div id="courses-section" class="tab-content">
            <div class="bg-white rounded-lg shadow-sm p-6 mb-8">
                <div class="flex flex-col sm:flex-row gap-4 items-center justify-between">
                    <div class="relative flex-1">
                        <input
                            type="text"
                            name="search-courses"
                            value="{{ search_query|default:'' }}"
                            placeholder="Cari kelas {{ category.name|lower }}..."
                            class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent"
                        >
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                            </svg>
                        </div>
                    </div>
                    <a
                        href="{% url 'courses_and_coach:show_courses' %}"
                        class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-lg text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 transition-colors"
                    >
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                        </svg>
                        Semua Kelas
                    </a>
                </div>
            </div>
            <div id="courses-container" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 mb-8">
                {% if courses %}
                    {% for course in courses %}
                        {% include 'courses_and_coach/partials/course_card.html' %}
                    {% endfor %}
                {% endif %}
            </div>
            <nav id="courses-pagination-controls" class="flex justify-center items-center gap-2 mb-8 {% if not courses %}hidden{% endif %}" aria-label="Pagination">
                <button class="first-btn-courses px-3 py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" onclick="goToFirstPageCourses()" title="Halaman Pertama">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m11 17-5-5 5-5"/><path d="m18 17-5-5 5-5"/></svg>
                </button>
                <button class="prev-btn-courses px-3 py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" onclick="changePageCourses(-1)">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
                </button>
                <span class="px-4 py-2 text-gray-700 font-medium">
                    Halaman <span class="current-page-courses">1</span> dari <span class="total-pages-courses">1</span>
                </span>
                <button class="next-btn-courses px-3 py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" onclick="changePageCourses(1)">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
                </button>
                <button class="last-btn-courses px-3 py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" onclick="goToLastPageCourses()" title="Halaman Terakhir">
                   <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m6 17 5-5-5-5"/><path d="m13 17 5-5-5-5"/></svg>
                </button>
            </nav>
            <div id="courses-empty-state" class="text-center py-16 {% if courses %}hidden{% endif %}">
                <div class="max-w-md mx-auto">
                    <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
                    </svg>
                    <h3 class="mt-4 text-lg font-medium text-gray-900">Belum ada kelas</h3>
                    <p class="mt-2 text-gray-500" id="courses-empty-message">
                        Belum ada kelas yang tersedia untuk kategori {{ category.name }}.
                    </p>
                </div>
            </div>
        </div>
        <div id="coaches-section" class="tab-content hidden">
            <div class="bg-white rounded-lg shadow-sm p-6 mb-8">
                <div class="flex flex-col sm:flex-row gap-4 items-center justify-between">
                    <div class="relative flex-1">
                        <input
                            type="text"
                            name="search-coaches"
                            placeholder="Cari coach di kategori {{ category.name|lower }}..."
                            class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent"
                        >
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                            </svg>
                        </div>
                    </div>
                    <a
                        href="{% url 'courses_and_coach:show_coaches' %}"
                        class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-lg text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 transition-colors"
                    >
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                        </svg>
                        Semua Coach
                    </a>
                </div>
            </div>
            <div id="coaches-container" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 mb-8">
            </div>
            <nav id="coaches-pagination-controls" class="flex justify-center items-center gap-2 mb-8 hidden" aria-label="Pagination">
                <button class="first-btn-coaches px-3 py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" onclick="goToFirstPageCoaches()" title="Halaman Pertama">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m11 17-5-5 5-5"/><path d="m18 17-5-5 5-5"/></svg>
                </button>
                <button class="prev-btn-coaches px-3 py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" onclick="changePageCoaches(-1)">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
                </button>
                <span class="px-4 py-2 text-gray-700 font-medium">
                    Halaman <span class="current-page-coaches">1</span> dari <span class="total-pages-coaches">1</span>
                </span>
                <button class="next-btn-coaches px-3 py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" onclick="changePageCoaches(1)">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
                </button>
                <button class="last-btn-coaches px-3 py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" onclick="goToLastPageCoaches()" title="Halaman Terakhir">
                   <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m6 17 5-5-5-5"/><path d="m13 17 5-5-5-5"/></svg>
                </button>
            </nav>
            <div id="coaches-empty-state" class="text-center py-16 hidden">
                <div class="text-center flex flex-col justify-center items-center gap-4 py-16 bg-white rounded-2xl shadow-lg">
                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-user-round-x-icon lucide-user-round-x"><path d="M2 21a8 8 0 0 1 11.873-7"/><circle cx="10" cy="8" r="5"/><path d="m17 17 5 5"/><path d="m22 17-5 5"/></svg>
                    <h3 class="mt-4 text-lg font-medium text-gray-900">Belum ada coach</h3>
                    <p class="mt-2 text-gray-500" id="coaches-empty-message">
                        Belum ada coach di kategori {{ category.name }}.
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
let searchTimeout;
let isLoadingCourses = false;
let isLoadingCoaches = false;
// Pagination state for courses
let currentPageCourses = {{ current_page|default:1 }};
let totalPagesCourses = {{ total_pages|default:1 }};
// Pagination state for coaches
let currentPageCoaches = 1;
let totalPagesCoaches = 1;
// Get CSRF token
const csrfToken = '{{ csrf_token }}';
const selectedCategory = "{{ category.name|escapejs }}";
document.addEventListener("DOMContentLoaded", function() {
    const searchCoursesInput = document.querySelector('input[name="search-courses"]');
    const searchCoachesInput = document.querySelector('input[name="search-coaches"]');
    // Real-time search for courses with debounce
    if (searchCoursesInput) {
        searchCoursesInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            currentPageCourses = 1;
            searchTimeout = setTimeout(() => {
                loadCourses();
            }, 500);
        });
        searchCoursesInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                clearTimeout(searchTimeout);
                currentPageCourses = 1;
                loadCourses();
            }
        });
    }
    // Real-time search for coaches with debounce
    if (searchCoachesInput) {
        searchCoachesInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            currentPageCoaches = 1;
            searchTimeout = setTimeout(() => {
                loadCoaches();
            }, 500);
        });
        searchCoachesInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                clearTimeout(searchTimeout);
                currentPageCoaches = 1;
                loadCoaches();
            }
        });
    }
    // Initialize pagination display
    document.querySelector('.current-page-courses').textContent = currentPageCourses;
    document.querySelector('.total-pages-courses').textContent = totalPagesCourses;
    updateCoursesPaginationButtons();
    window.loadCourses = loadCourses;
    window.loadCoaches = loadCoaches;
});
function switchTab(tab) {
    const coursesSection = document.getElementById('courses-section');
    const coachesSection = document.getElementById('coaches-section');
    const coursesTab = document.getElementById('courses-tab');
    const coachesTab = document.getElementById('coaches-tab');
    if (tab === 'courses') {
        coursesSection.classList.remove('hidden');
        coachesSection.classList.add('hidden');
        coursesTab.classList.add('border-b-2', 'border-primary', 'text-primary');
        coursesTab.classList.remove('border-b-2', 'border-transparent', 'text-gray-600');
        coachesTab.classList.remove('border-b-2', 'border-primary', 'text-primary');
        coachesTab.classList.add('border-b-2', 'border-transparent', 'text-gray-600');
    } else if (tab === 'coaches') {
        coachesSection.classList.remove('hidden');
        coursesSection.classList.add('hidden');
        coachesTab.classList.add('border-b-2', 'border-primary', 'text-primary');
        coachesTab.classList.remove('border-b-2', 'border-transparent', 'text-gray-600');
        coursesTab.classList.remove('border-b-2', 'border-primary', 'text-primary');
        coursesTab.classList.add('border-b-2', 'border-transparent', 'text-gray-600');
        // Load coaches if not already loaded
        if (document.getElementById('coaches-container').innerHTML.trim() === '') {
            loadCoaches();
        }
    }
}
async function loadCourses() {
    console.log("loadCourses called");
    if (isLoadingCourses) return;
    isLoadingCourses = true;
    const coursesContainer = document.getElementById('courses-container');
    const emptyState = document.getElementById('courses-empty-state');
    try {
        // Show loading state
        coursesContainer.innerHTML = `
            <div class="col-span-full text-center py-16">
                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
                <p class="text-gray-600">Memuat kelas...</p>
            </div>
        `;
        emptyState.classList.add('hidden');
        const searchInput = document.querySelector('input[name="search-courses"]');
        const searchQuery = searchInput ? searchInput.value.trim() : '';
        const params = new URLSearchParams();
        if (searchQuery) {
            params.append('search', searchQuery);
        }
        if (selectedCategory) {
            params.append('category', selectedCategory);
        }
        params.append('page', currentPageCourses);
        console.log('Params:', params.toString());
        const response = await fetch(`{% url 'courses_and_coach:courses_card_ajax' %}?${params.toString()}`, {
            method: 'GET',
            headers: {
                'X-CSRFToken': csrfToken,
            }
        });
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        console.log('Response data:', data);
        totalPagesCourses = data.total_pages || 1;
        currentPageCourses = data.current_page || 1;
        document.querySelector('.current-page-courses').textContent = currentPageCourses;
        document.querySelector('.total-pages-courses').textContent = totalPagesCourses;
        updateCoursesPaginationButtons();
        if (data.html && data.html.trim()) {
            coursesContainer.innerHTML = data.html;
            emptyState.classList.add('hidden');
            document.getElementById('courses-pagination-controls').classList.remove('hidden');
        } else {
            coursesContainer.innerHTML = '';
            emptyState.classList.remove('hidden');
            document.getElementById('courses-pagination-controls').classList.add('hidden');
            const emptyMessage = document.getElementById('courses-empty-message');
            if (emptyMessage) {
                if (searchQuery) {
                    emptyMessage.textContent = `Tidak ada kelas yang cocok dengan pencarian "${searchQuery}" di kategori ${selectedCategory}.`;
                } else {
                    emptyMessage.textContent = `Belum ada kelas yang tersedia untuk kategori ${selectedCategory}.`;
                }
            }
        }
    } catch (error) {
        console.error('Error loading courses:', error);
        coursesContainer.innerHTML = `
            <div class="col-span-full text-center py-16">
                <div class="text-red-500 mb-4">
                    <svg class="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    <h3 class="text-lg font-semibold">Terjadi Kesalahan</h3>
                    <p class="text-gray-600 mt-2">Gagal memuat kelas. Silakan coba lagi.</p>
                    <button onclick="loadCourses()" class="mt-4 bg-primary text-white px-4 py-2 rounded-lg hover:bg-green-600">
                        Coba Lagi
                    </button>
                </div>
            </div>
        `;
        emptyState.classList.add('hidden');
        document.getElementById('courses-pagination-controls').classList.add('hidden');
    } finally {
        isLoadingCourses = false;
    }
}
async function loadCoaches() {
    console.log("loadCoaches called");
    if (isLoadingCoaches) return;
    isLoadingCoaches = true;
    const coachesContainer = document.getElementById('coaches-container');
    const emptyState = document.getElementById('coaches-empty-state');
    try {
        // Show loading state
        coachesContainer.innerHTML = `
            <div class="col-span-full text-center py-16">
                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
                <p class="text-gray-600">Memuat coach...</p>
            </div>
        `;
        emptyState.classList.add('hidden');
        const searchInput = document.querySelector('input[name="search-coaches"]');
        const searchQuery = searchInput ? searchInput.value.trim() : '';
        const params = new URLSearchParams();
        if (searchQuery) {
            params.append('search', searchQuery);
        }
        if (selectedCategory) {
            params.append('category', selectedCategory);
        }
        params.append('page', currentPageCoaches);
        console.log('Coaches params:', params.toString());
        const response = await fetch(`{% url 'courses_and_coach:coaches_card_ajax' %}?${params.toString()}`, {
            method: 'GET',
            headers: {
                'X-CSRFToken': csrfToken,
            }
        });
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        console.log('Coaches response data:', data);
        totalPagesCoaches = data.total_pages || 1;
        currentPageCoaches = data.current_page || 1;
        document.querySelector('.current-page-coaches').textContent = currentPageCoaches;
        document.querySelector('.total-pages-coaches').textContent = totalPagesCoaches;
        updateCoachesPaginationButtons();
        if (data.html && data.html.trim()) {
            coachesContainer.innerHTML = data.html;
            emptyState.classList.add('hidden');
            document.getElementById('coaches-pagination-controls').classList.remove('hidden');
        } else {
            coachesContainer.innerHTML = '';
            emptyState.classList.remove('hidden');
            document.getElementById('coaches-pagination-controls').classList.add('hidden');
            const emptyMessage = document.getElementById('coaches-empty-message');
            if (emptyMessage) {
                if (searchQuery) {
                    emptyMessage.textContent = `Tidak ada coach yang cocok dengan pencarian "${searchQuery}" di kategori ${selectedCategory}.`;
                } else {
                    emptyMessage.textContent = `Belum ada coach di kategori ${selectedCategory}.`;
                }
            }
        }
    } catch (error) {
        console.error('Error loading coaches:', error);
        coachesContainer.innerHTML = `
            <div class="col-span-full text-center py-16">
                <div class="text-red-500 mb-4">
                    <svg class="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    <h3 class="text-lg font-semibold">Terjadi Kesalahan</h3>
                    <p class="text-gray-600 mt-2">Gagal memuat coach. Silakan coba lagi.</p>
                    <button onclick="loadCoaches()" class="mt-4 bg-primary text-white px-4 py-2 rounded-lg hover:bg-green-600">
                        Coba Lagi
                    </button>
                </div>
            </div>
        `;
        emptyState.classList.add('hidden');
        document.getElementById('coaches-pagination-controls').classList.add('hidden');
    } finally {
        isLoadingCoaches = false;
    }
}
function updateCoursesPaginationButtons() {
    document.querySelector('.first-btn-courses').disabled = currentPageCourses === 1;
    document.querySelector('.prev-btn-courses').disabled = currentPageCourses === 1;
    document.querySelector('.next-btn-courses').disabled = currentPageCourses === totalPagesCourses;
    document.querySelector('.last-btn-courses').disabled = currentPageCourses === totalPagesCourses;
}
function updateCoachesPaginationButtons() {
    document.querySelector('.first-btn-coaches').disabled = currentPageCoaches === 1;
    document.querySelector('.prev-btn-coaches').disabled = currentPageCoaches === 1;
    document.querySelector('.next-btn-coaches').disabled = currentPageCoaches === totalPagesCoaches;
    document.querySelector('.last-btn-coaches').disabled = currentPageCoaches === totalPagesCoaches;
}
function changePageCourses(direction) {
    const newPage = currentPageCourses + direction;
    if (newPage < 1 || newPage > totalPagesCourses) return;
    currentPageCourses = newPage;
    loadCourses();
}
function changePageCoaches(direction) {
    const newPage = currentPageCoaches + direction;
    if (newPage < 1 || newPage > totalPagesCoaches) return;
    currentPageCoaches = newPage;
    loadCoaches();
}
function goToFirstPageCourses() {
    if (currentPageCourses === 1) return;
    currentPageCourses = 1;
    loadCourses();
}
function goToLastPageCourses() {
    if (currentPageCourses === totalPagesCourses) return;
    currentPageCourses = totalPagesCourses;
    loadCourses();
}
function goToFirstPageCoaches() {
    if (currentPageCoaches === 1) return;
    currentPageCoaches = 1;
    loadCoaches();
}
function goToLastPageCoaches() {
    if (currentPageCoaches === totalPagesCoaches) return;
    currentPageCoaches = totalPagesCoaches;
    loadCoaches();
}
</script>
</script>
{% endblock %}
````

## File: courses_and_coach/templates/courses_and_coach/coaches_list.html
````html
{% extends "base.html" %}
{% load static %}
{% block title %}Daftar Coach - MamiCoach{% endblock %}
{% block content %}
<div class="bg-gradient-to-b from-blue-50 to-white min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
            <h1 class="text-4xl sm:text-5xl font-bold text-gray-900 mb-2">Temukan Coach Terbaik</h1>
            <p class="text-lg text-gray-600">Belajar dari para ahli di bidangnya masing-masing</p>
        </div>
        <div class="bg-white rounded-3xl shadow-lg p-6 mb-8">
            <div class="space-y-4">
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                    </div>
                    <input
                        type="text"
                        name="search"
                        id="search-input"
                        value="{{ search_query|default:'' }}"
                        placeholder="Cari coach berdasarkan nama..."
                        class="block w-full pl-12 pr-4 py-4 border border-gray-300 rounded-2xl leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-primary focus:border-primary"
                    >
                </div>
                <div class="flex justify-between items-center pt-4 border-t border-gray-200">
                    <div class="text-sm text-gray-600" id="coach-count-info">
                        {% if coaches %}
                            Menampilkan {{ coaches|length }} dari {{ coaches.paginator.count }} coach
                        {% else %}
                            Tidak ada coach ditemukan
                        {% endif %}
                    </div>
                    <div class="flex gap-2">
                        <button type="button" onclick="clearSearch()" class="bg-gray-200 text-gray-700 px-6 py-2 rounded-xl font-medium hover:bg-gray-300 transition-colors duration-200">
                            Reset
                        </button>
                        <button type="button" onclick="loadCoaches()" class="bg-primary text-white px-6 py-2 rounded-xl font-medium hover:bg-green-600 transition-colors duration-200">
                            Cari
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div id="coaches-container" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 mb-8">
            {% if coaches %}
                {% for coach in coaches %}
                {% include "courses_and_coach/partials/coach_card.html" with coach=coach %}
                {% endfor %}
            {% else %}
                <div class="col-span-full text-center py-16">
                    <div class="max-w-md flex flex-col justify-center items-center mx-auto">
                        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-user-round-x-icon lucide-user-round-x"><path d="M2 21a8 8 0 0 1 11.873-7"/><circle cx="10" cy="8" r="5"/><path d="m17 17 5 5"/><path d="m22 17-5 5"/></svg>
                        <h3 class="text-2xl font-bold text-gray-900 mb-2">
                            {% if search_query %}
                                Tidak Ada Coach Ditemukan
                            {% else %}
                                Belum Ada Coach
                            {% endif %}
                        </h3>
                        <p class="text-gray-600 mb-4">
                            {% if search_query %}
                                Tidak ada coach yang cocok dengan pencarian "{{ search_query }}"
                            {% else %}
                                Belum ada coach yang terdaftar di platform kami.
                            {% endif %}
                        </p>
                        {% if search_query %}
                        <button onclick="clearSearch()" class="inline-flex items-center space-x-2 bg-primary text-white px-6 py-3 rounded-2xl font-semibold hover:bg-green-600 transition-colors duration-200">
                            <span>Lihat Semua Coach</span>
                        </button>
                        {% endif %}
                    </div>
                </div>
            {% endif %}
        </div>
        <nav id="pagination-controls" class="flex justify-center items-center gap-2 mb-8 {% if not coaches %}hidden{% endif %}" aria-label="Pagination">
            <button id="first-btn" onclick="goToFirstPage()" class="px-3 cursor-pointer py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" title="Halaman Pertama">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevrons-left-icon lucide-chevrons-left"><path d="m11 17-5-5 5-5"/><path d="m18 17-5-5 5-5"/></svg>
            </button>
            <button id="prev-btn" onclick="changePage(-1)" class="px-3 cursor-pointer py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-left-icon lucide-chevron-left"><path d="m15 18-6-6 6-6"/></svg>
            </button>
            <span id="page-info" class="px-4 cursor-pointer py-2 text-gray-700 font-medium">
                Halaman <span id="current-page">1</span> dari <span id="total-pages">1</span>
            </span>
            <button id="next-btn" onclick="changePage(1)" class="px-3 cursor-pointer py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-right-icon lucide-chevron-right"><path d="m9 18 6-6-6-6"/></svg>
            </button>
            <button id="last-btn" onclick="goToLastPage()" class="px-3 cursor-pointer py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" title="Halaman Terakhir">
               <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevrons-right-icon lucide-chevrons-right"><path d="m6 17 5-5-5-5"/><path d="m13 17 5-5-5-5"/></svg>
            </button>
        </nav>
    </div>
</div>
<script>
let searchTimeout;
let isLoading = false;
let currentPage = {{ current_page|default:1 }};
let totalPages = {{ total_pages|default:1 }};
const csrfToken = '{{ csrf_token }}';
document.addEventListener("DOMContentLoaded", function() {
    const searchInput = document.getElementById('search-input');
    const coachesContainer = document.getElementById('coaches-container');
    // Initialize pagination display on page load
    document.getElementById('current-page').textContent = currentPage;
    document.getElementById('total-pages').textContent = totalPages;
    updatePaginationButtons();
    // Real-time search with debounce
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            currentPage = 1; // Reset to first page on search
            searchTimeout = setTimeout(() => {
                loadCoaches();
            }, 500); // 500ms delay
        });
        // Add Enter key support for search input
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                clearTimeout(searchTimeout);
                currentPage = 1;
                loadCoaches();
            }
        });
    }
    window.loadCoaches = loadCoaches;
});
async function loadCoaches() {
    if (isLoading) return;
    isLoading = true;
    const coachesContainer = document.getElementById('coaches-container');
    const paginationControls = document.getElementById('pagination-controls');
    try {
        // Show loading state
        coachesContainer.innerHTML = `
            <div class="col-span-full text-center py-16">
                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
                <p class="text-gray-600">Memuat coach...</p>
            </div>
        `;
        const params = new URLSearchParams();
        params.append('page', currentPage);
        // Get search query
        const searchInput = document.getElementById('search-input');
        const searchQuery = searchInput ? searchInput.value.trim() : '';
        if (searchQuery) {
            params.append('search', searchQuery);
        }
        console.log('Loading coaches with params:', params.toString());
        const response = await fetch(`{% url 'courses_and_coach:coaches_card_ajax' %}?${params.toString()}`, {
            method: 'GET',
            headers: {
                'X-CSRFToken': csrfToken,
            }
        });
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        console.log('Response data:', data);
        // Update pagination info
        totalPages = data.total_pages || 1;
        currentPage = data.current_page || 1;
        // Update pagination UI
        document.getElementById('current-page').textContent = currentPage;
        document.getElementById('total-pages').textContent = totalPages;
        updatePaginationButtons();
        // Update coaches display
        if (data.html && data.html.trim()) {
            coachesContainer.innerHTML = data.html;
            paginationControls.classList.remove('hidden');
            // Update coach count info
            const coachCountInfo = document.getElementById('coach-count-info');
            if (coachCountInfo && data.count !== undefined) {
                if (data.count > 0) {
                    coachCountInfo.textContent = `Menampilkan ${data.count} dari ${data.total_count} coach`;
                } else {
                    coachCountInfo.textContent = 'Tidak ada coach ditemukan';
                }
            }
        } else {
            // Show empty state
            coachesContainer.innerHTML = `
                <div class="col-span-full text-center py-16">
                    <div class="max-w-md flex flex-col justify-center items-center mx-auto">
                        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-user-round-x-icon lucide-user-round-x"><path d="M2 21a8 8 0 0 1 11.873-7"/><circle cx="10" cy="8" r="5"/><path d="m17 17 5 5"/><path d="m22 17-5 5"/></svg>
                        <h3 class="text-2xl font-bold text-gray-900 mb-2">Tidak Ada Coach Ditemukan</h3>
                        <p class="text-gray-600 mb-4">
                            ${searchQuery ? `Tidak ada coach yang cocok dengan pencarian "${searchQuery}"` : 'Belum ada coach yang terdaftar di platform kami.'}
                        </p>
                        ${searchQuery ? '<button onclick="clearSearch()" class="inline-flex items-center space-x-2 bg-primary text-white px-6 py-3 rounded-2xl font-semibold hover:bg-green-600 transition-colors duration-200"><span>Lihat Semua Coach</span></button>' : ''}
                    </div>
                </div>
            `;
            paginationControls.classList.add('hidden');
            const coachCountInfo = document.getElementById('coach-count-info');
            if (coachCountInfo) {
                coachCountInfo.textContent = 'Tidak ada coach ditemukan';
            }
        }
    } catch (error) {
        console.error('Error loading coaches:', error);
        // Show error state
        coachesContainer.innerHTML = `
            <div class="col-span-full text-center py-16">
                <div class="text-red-500 mb-4">
                    <svg class="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    <h3 class="text-lg font-semibold">Terjadi Kesalahan</h3>
                    <p class="text-gray-600 mt-2">Gagal memuat coach. Silakan coba lagi.</p>
                    <button onclick="loadCoaches()" class="mt-4 bg-primary text-white px-4 py-2 rounded-lg hover:bg-green-600">
                        Coba Lagi
                    </button>
                </div>
            </div>
        `;
        paginationControls.classList.add('hidden');
    } finally {
        isLoading = false;
    }
}
function clearSearch() {
    const searchInput = document.getElementById('search-input');
    if (searchInput) {
        searchInput.value = '';
    }
    currentPage = 1;
    loadCoaches();
}
function updatePaginationButtons() {
    document.getElementById('first-btn').disabled = currentPage === 1;
    document.getElementById('prev-btn').disabled = currentPage === 1;
    document.getElementById('next-btn').disabled = currentPage === totalPages;
    document.getElementById('last-btn').disabled = currentPage === totalPages;
}
function changePage(direction) {
    const newPage = currentPage + direction;
    if (newPage < 1 || newPage > totalPages) return;
    currentPage = newPage;
    loadCoaches();
}
function goToFirstPage() {
    if (currentPage === 1) return;
    currentPage = 1;
    loadCoaches();
}
function goToLastPage() {
    if (currentPage === totalPages) return;
    currentPage = totalPages;
    loadCoaches();
}
</script>
{% endblock %}
````

## File: courses_and_coach/templates/courses_and_coach/courses_list.html
````html
{% extends "base.html" %}
{% load static %}
{% block title %}Semua Kelas - MamiCoach{% endblock %}
{% block content %}
<div class="bg-gray-50 min-h-screen">
    <div class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <div class="text-center">
                <h1 class="text-3xl sm:text-4xl font-bold text-gray-900 mb-4">
                    Temukan Kelas <span class="text-primary">Olahraga</span> Favoritmu
                </h1>
                <p class="text-lg text-gray-600 max-w-2xl mx-auto">
                    Bergabung dengan ribuan orang yang sudah memulai perjalanan fitness mereka
                </p>
            </div>
        </div>
    </div>
    {% if categories %}
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-8">
        <div class="text-center mb-8">
            <h2 class="text-2xl font-bold text-gray-900 mb-2">Jelajahi Kategori</h2>
            <p class="text-gray-600">Pilih kategori olahraga yang sesuai dengan minatmu</p>
        </div>
        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4 mb-8">
            {% for category in categories %}
            <a href="{% url 'courses_and_coach:category_detail' category.name %}"
               class="group bg-white rounded-2xl shadow-sm hover:shadow-lg transition-all duration-300 overflow-hidden">
                {% if category.thumbnail_url %}
                <div class="aspect-square overflow-hidden">
                    <img
                        src="{{ category.thumbnail_url }}"
                        alt="{{ category.name }}"
                        class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                    >
                </div>
                {% else %}
                <div class="aspect-square bg-gradient-to-br from-pink-400 to-purple-500 flex items-center justify-center">
                    <svg class="w-12 h-12 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                    </svg>
                </div>
                {% endif %}
                <div class="p-3">
                    <h3 class="font-semibold text-gray-900 text-sm text-center group-hover:text-primary transition-colors duration-200">
                        {{ category.name }}
                    </h3>
                </div>
            </a>
            {% endfor %}
        </div>
    </div>
    {% endif %}
    <div id="list-section" class="my-0 w-full h-20 md:h-12 ">
    </div>
    <div  class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="bg-white rounded-3xl shadow-lg p-6 mb-8">
            <div class="space-y-4" id="search-form">
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                    </div>
                    <input
                        type="text"
                        name="courses-search"
                        value="{{ search_query|default:'' }}"
                        placeholder="Cari kelas..."
                        class="block w-full pl-12 pr-4 py-4 border border-gray-300 rounded-2xl leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-primary focus:border-primary"
                    >
                </div>
                <div class="flex flex-wrap gap-3 items-center">
                    <span class="text-sm font-medium text-gray-700">Kategori:</span>
                    <button type="button"
                            class="category-filter cursor-pointer px-4 py-2 rounded-full text-sm font-medium transition-colors duration-200 {% if not selected_category %}bg-primary text-white{% else %}bg-gray-100 text-gray-700 hover:bg-gray-200{% endif %}"
                            data-category="">
                        Semua
                    </button>
                    {% for category in categories %}
                    <button type="button"
                            class="category-filter  cursor-pointer px-4 py-2 rounded-full text-sm font-medium transition-colors duration-200 bg-gray-100 text-gray-700 hover:bg-gray-200 hover:bg-primary hover:text-white"
                            data-category="{{category.name}}">
                        {{ category.name }}
                    </button>
                    {% endfor %}
                    <input type="hidden" name="category" id="category-input" value="{{ selected_category|default:'' }}">
                </div>
                <div class="flex justify-between items-center pt-4 border-t border-gray-200">
                    <div class="text-sm text-gray-600" id="class-count-info">
                        {% if courses %}
                            Menampilkan {{ courses|length }} dari {{courses.paginator.count}} kelas
                        {% else %}
                            Tidak ada kelas ditemukan
                        {% endif %}
                    </div>
                    <button type="button" onclick="loadCourses()" class="bg-primary text-white px-6 py-2 rounded-xl font-medium hover:bg-green-600 transition-colors duration-200">
                        Cari
                    </button>
                </div>
            </div>
        </div>
        <div id="courses-container" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 mb-8">
            {% if courses %}
                {% for course in courses %}
                    {% include "courses_and_coach/partials/course_card.html" with course=course %}
                {% endfor %}
            {% endif %}
        </div>
        <nav id="pagination-controls" class="flex justify-center items-center gap-2 mb-8" aria-label="Pagination">
            <button id="first-btn" onclick="goToFirstPage()" class="px-3 cursor-pointer py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" title="Halaman Pertama">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevrons-left-icon lucide-chevrons-left"><path d="m11 17-5-5 5-5"/><path d="m18 17-5-5 5-5"/></svg>
            </button>
            <button id="prev-btn" onclick="changePage(-1)" class="px-3 cursor-pointer py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-left-icon lucide-chevron-left"><path d="m15 18-6-6 6-6"/></svg>
            </button>
            <span id="page-info" class="px-4 cursor-pointer py-2 text-gray-700 font-medium">
                Halaman <span id="current-page">1</span> dari <span id="total-pages">1</span>
            </span>
            <button id="next-btn" onclick="changePage(1)" class="px-3 cursor-pointer py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-right-icon lucide-chevron-right"><path d="m9 18 6-6-6-6"/></svg>
            </button>
            <button id="last-btn" onclick="goToLastPage()" class="px-3 cursor-pointer py-2 rounded-lg bg-primary hover:bg-primary/50 text-white transition-colors disabled:opacity-50 disabled:cursor-not-allowed" title="Halaman Terakhir">
               <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevrons-right-icon lucide-chevrons-right"><path d="m6 17 5-5-5-5"/><path d="m13 17 5-5-5-5"/></svg>
            </button>
        </nav>
        <div id="empty-state" class="text-center py-16 {% if courses %}hidden{% endif %}">
            <div class="max-w-md mx-auto flex flex-col justify-center items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="96" height="96" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-brush-cleaning-icon lucide-brush-cleaning"><path d="m16 22-1-4"/><path d="M19 13.99a1 1 0 0 0 1-1V12a2 2 0 0 0-2-2h-3a1 1 0 0 1-1-1V4a2 2 0 0 0-4 0v5a1 1 0 0 1-1 1H6a2 2 0 0 0-2 2v.99a1 1 0 0 0 1 1"/><path d="M5 14h14l1.973 6.767A1 1 0 0 1 20 22H4a1 1 0 0 1-.973-1.233z"/><path d="m8 22 1-4"/></svg>
                <h3 class="text-xl font-semibold text-gray-900 mb-2">Belum Ada Kelas</h3>
                <p id="empty-message" class="text-gray-600 mb-6">Tidak ada kelas ditemukan</p>
                <button onclick="clearSearch()" class="inline-flex items-center space-x-2 bg-primary text-white px-6 py-3 rounded-2xl font-semibold hover:bg-green-600 transition-colors duration-200">
                    <span>Lihat Semua Kelas</span>
                </button>
            </div>
        </div>
    </div>
</div>
<script>
let searchTimeout;
let isLoading = false;
let currentPage = {{ current_page|default:1 }};
let totalPages = {{ total_pages|default:1 }};
// Get CSRF token
const csrfToken = '{{ csrf_token }}';
document.addEventListener("DOMContentLoaded", function() {
    const searchInput = document.querySelector('input[name="courses-search"]');
    const categoryButtons = document.querySelectorAll('.category-filter');
    const coursesContainer = document.getElementById('courses-container');
    const emptyState = document.getElementById('empty-state');
    const classCountInfo = document.getElementsByClassName('class-count-info');
    // Real-time search with debounce
    searchInput.addEventListener('input', function() {
        clearTimeout(searchTimeout);
        currentPage = 1; // Reset to first page on search
        totalPages = 1;
        searchTimeout = setTimeout(() => {
            loadCourses();
        }, 500); // 500ms delay
    });
    categoryButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            currentPage = 1;
            totalPages = 1;
            const categoryInput = document.getElementById('category-input');
            const selectedCategory = this.getAttribute('data-category');
            if (categoryInput) {
                categoryInput.value = selectedCategory;
                // console.log("set to ", categoryInput.value)
            }
            categoryButtons.forEach(btn => {
                btn.classList.remove('bg-primary', 'text-white');
                btn.classList.add('bg-gray-100', 'text-gray-700');
            });
            this.classList.remove('bg-gray-100', 'text-gray-700');
            this.classList.add('bg-primary', 'text-white');
            loadCourses();
        });
    });
    // Add Enter key support for search input
    searchInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            clearTimeout(searchTimeout);
            loadCourses();
        }
    });
    async function loadCourses() {
        console.log("loadCourses called");
        if (isLoading) return;
        isLoading = true;
        try {
            // Show loading state
            coursesContainer.innerHTML = `
                <div class="col-span-full text-center py-16">
                    <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
                    <p class="text-gray-600">Memuat kelas...</p>
                </div>
            `;
            // Hide empty state during loading
            emptyState.classList.add('hidden');
            // Get form values properly
            const searchInput = document.querySelector('input[name="courses-search"]');
            const categoryInput = document.getElementById('category-input');
            const searchQuery = searchInput ? searchInput.value.trim() : '';
            const selectedCategory = categoryInput ? categoryInput.value.trim() : '';
            // Build URL parameters
            const params = new URLSearchParams();
            if (searchQuery) {
                params.append('search', searchQuery);
            }
            if (selectedCategory) {
                params.append('category', selectedCategory);
            }
            params.append('page', currentPage);
            console.log('Search Query:', searchQuery);
            console.log('Category:', selectedCategory);
            console.log('Page:', currentPage);
            console.log('Params:', params.toString());
            // Fetch data
            const response = await fetch(`{% url 'courses_and_coach:courses_card_ajax' %}?${params.toString()}`, {
                method: 'GET',
                headers: {
                    'X-CSRFToken': csrfToken,
                }
            });
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data = await response.json();
            console.log('Response data:', data);
            // Update pagination info
            totalPages = data.total_pages || 1;
            currentPage = data.current_page || 1;
            // Update pagination UI
            document.getElementById('current-page').textContent = currentPage;
            document.getElementById('total-pages').textContent = totalPages;
            updatePaginationButtons();
            if (data.html && data.html.trim()) {
                coursesContainer.innerHTML = data.html;
                emptyState.classList.add('hidden');
                document.getElementById('pagination-controls').classList.remove('hidden');
                const classCountInfo = document.getElementById('class-count-info');
                if (classCountInfo && data.count !== undefined) {
                    if (data.count > 0) {
                        classCountInfo.textContent = `Menampilkan ${data.count} dari ${data.total_count} kelas`;
                    } else {
                        classCountInfo.textContent = 'Tidak ada kelas ditemukan';
                    }
                }
            } else {
                coursesContainer.innerHTML = '';
                emptyState.classList.remove('hidden');
                document.getElementById('pagination-controls').classList.add('hidden');
                const classCountInfo = document.getElementById('class-count-info');
                if (classCountInfo) {
                    classCountInfo.textContent = 'Tidak ada kelas ditemukan';
                }
                const emptyMessage = document.getElementById('empty-message');
                if (emptyMessage) {
                    if (searchQuery) {
                        emptyMessage.textContent = `Tidak ada kelas yang cocok dengan pencarian "${searchQuery}"`;
                    } else if (selectedCategory) {
                        emptyMessage.textContent = `Tidak ada kelas dalam kategori "${selectedCategory}"`;
                    } else {
                        emptyMessage.textContent = 'Tidak ada kelas ditemukan';
                    }
                }
            }
        } catch (error) {
            console.error('Error loading courses:', error);
            coursesContainer.innerHTML = `
                <div class="col-span-full text-center py-16">
                    <div class="text-red-500 mb-4">
                        <svg class="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <h3 class="text-lg font-semibold">Terjadi Kesalahan</h3>
                        <p class="text-gray-600 mt-2">Gagal memuat kelas. Silakan coba lagi.</p>
                        <button onclick="loadCourses()" class="mt-4 bg-primary text-white px-4 py-2 rounded-lg hover:bg-green-600">
                            Coba Lagi
                        </button>
                    </div>
                </div>
            `;
            emptyState.classList.add('hidden');
            document.getElementById('pagination-controls').classList.add('hidden');
        } finally {
            isLoading = false;
        }
    }
    window.loadCourses = loadCourses;
    // Initialize pagination display on page load
    document.getElementById('current-page').textContent = currentPage;
    document.getElementById('total-pages').textContent = totalPages;
    updatePaginationButtons();
});
function updatePaginationButtons() {
    document.getElementById('first-btn').disabled = currentPage === 1;
    document.getElementById('prev-btn').disabled = currentPage === 1;
    document.getElementById('next-btn').disabled = currentPage === totalPages;
    document.getElementById('last-btn').disabled = currentPage === totalPages;
}
function changePage(direction) {
    const newPage = currentPage + direction;
    if (newPage < 1 || newPage > totalPages) return;
    currentPage = newPage;
    loadCourses();
}
function goToFirstPage() {
    if (currentPage === 1) return;
    currentPage = 1;
    loadCourses();
}
function goToLastPage() {
    if (currentPage === totalPages) return;
    currentPage = totalPages;
    loadCourses();
}
function clearSearch() {
    const searchInput = document.querySelector('input[name="courses-search"]');
    const categoryInput = document.getElementById('category-input');
    // Reset pagination
    currentPage = 1;
    totalPages = 1;
    if (searchInput) {
        searchInput.value = '';
    }
    if (categoryInput) {
        categoryInput.value = '';
    }
    const categoryButtons = document.querySelectorAll('.category-filter');
    categoryButtons.forEach(btn => {
        btn.classList.remove('bg-primary', 'text-white');
        btn.classList.add('bg-gray-100', 'text-gray-700');
    });
    const allButton = document.querySelector('.category-filter[data-category=""]');
    if (allButton) {
        allButton.classList.remove('bg-gray-100', 'text-gray-700');
        allButton.classList.add('bg-primary', 'text-white');
    }
    if (typeof window.loadCourses === 'function') {
        window.loadCourses();
    }
}
</script>
{% endblock %}
````

## File: courses_and_coach/admin.py
````python

````

## File: courses_and_coach/apps.py
````python
class CoursesAndCoachConfig(AppConfig)
⋮----
default_auto_field = "django.db.models.BigAutoField"
name = "courses_and_coach"
````

## File: courses_and_coach/forms.py
````python
class CourseForm(forms.ModelForm)
⋮----
class Meta
⋮----
model = Course
fields = [
widgets = {
def __init__(self, *args, **kwargs)
````

## File: courses_and_coach/models.py
````python
class Category(models.Model)
⋮----
name = models.CharField(max_length=255, unique=True)
description = models.TextField(null=True, blank=True)
thumbnail_url = models.URLField(max_length=500, null=True, blank=True)
class Meta
⋮----
verbose_name_plural = "Categories"
ordering = ["name"]
def __str__(self)
def get_url_name(self)
class Course(models.Model)
⋮----
coach = models.ForeignKey(
category = models.ForeignKey(
title = models.CharField(max_length=255)
description = models.TextField()
location = models.CharField(
price = models.PositiveIntegerField(
duration = models.PositiveIntegerField(help_text="Duration in minutes")
rating = models.FloatField(default=0.0)
rating_count = models.PositiveIntegerField(default=0)
⋮----
created_at = models.DateTimeField(auto_now_add=True)
updated_at = models.DateTimeField(auto_now=True)
⋮----
ordering = ["-created_at"]
indexes = [
⋮----
@property
    def price_formatted(self)
⋮----
@property
    def duration_formatted(self)
⋮----
hours = self.duration // 60
minutes = self.duration % 60
````

## File: courses_and_coach/urls.py
````python
app_name = "courses_and_coach"
urlpatterns = [
````

## File: courses_and_coach/views.py
````python
def show_courses(request)
⋮----
courses = Course.objects.all().select_related("coach", "category")
categories = Category.objects.all()
category_filter = request.GET.get("category")
⋮----
courses = courses.filter(category__name=category_filter)
search_query = request.GET.get("search")
⋮----
courses = courses.filter(title__icontains=search_query)
paginator = Paginator(courses, 12)
page_number = request.GET.get("page", 1)
page_obj = paginator.get_page(page_number)
context = {
⋮----
def course_details(request, course_id)
⋮----
course = get_object_or_404(Course, id=course_id)
related_courses = Course.objects.filter(category=course.category).exclude(
reviews = (
⋮----
@login_required(login_url="user_profile:login")
def create_course(request)
⋮----
coach_profile = request.user.coachprofile
⋮----
form = CourseForm(request.POST)
⋮----
course = form.save(commit=False)
⋮----
form = CourseForm()
⋮----
def category_detail(request, category_name)
⋮----
category = get_object_or_404(Category, name__iexact=category_name)
all_courses_in_category = Course.objects.filter(category=category).select_related("coach")
courses = all_courses_in_category
⋮----
page_number = request.GET.get("page")
⋮----
coaches_with_expertise = CoachProfile.objects.all()
coaches_count = 0
category_name_lower = category.name.lower()
⋮----
@login_required(login_url="user_profile:login")
def my_courses(request)
⋮----
courses = Course.objects.filter(coach=coach_profile).order_by("-created_at")
⋮----
def courses_ajax(request)
⋮----
courses_list = Course.objects.all()
⋮----
courses_list = courses_list.filter(title__icontains=search_query)
category_detail = request.GET.get("category")
⋮----
courses_list = courses_list.filter(category__name__iexact=category_detail)
page = request.GET.get("page", 1)
paginator = Paginator(courses_list, 12)
page_obj = paginator.get_page(page)
data = [
⋮----
def courses_card_ajax(request)
⋮----
html = "".join(
⋮----
def courses_by_id_ajax(request, course_id)
⋮----
data = {
⋮----
@login_required(login_url="user_profile:login")
def edit_course(request, course_id)
⋮----
form = CourseForm(request.POST, instance=course)
⋮----
form = CourseForm(instance=course)
context = {"form": form, "course": course}
⋮----
@login_required(login_url="user_profile:login")
def delete_course(request, course_id)
⋮----
context = {"course": course}
⋮----
def show_coaches(request)
⋮----
coaches = CoachProfile.objects.all()
⋮----
coaches = (
paginator = Paginator(coaches, 12)
⋮----
def coaches_card_ajax(request)
⋮----
coaches_list = CoachProfile.objects.all()
⋮----
filtered_coaches = []
⋮----
coaches_list = coaches_list.filter(id__in=filtered_coaches)
⋮----
coaches_list = (
⋮----
paginator = Paginator(coaches_list, 12)
⋮----
def coach_details(request, coach_id)
⋮----
coach = get_object_or_404(CoachProfile, id=coach_id)
courses = Course.objects.filter(coach=coach)
coach_reviews = Review.objects.filter(coach=coach).select_related('user', 'course').order_by('-created_at')
````

## File: main/management/commands/crawl_superprof.py
````python
DEFAULT_HEADERS = {
DEFAULT_COOKIES = {
REQUEST_TIMEOUT = 20
MAX_RETRIES_DEFAULT = 3
SLEEP_DEFAULT = 1.0
PRICE_MIN_RP = 10_000
_USER_BY_NAME_CACHE: dict[str, int] = {}
def split_name(full_name: str) -> tuple[str, str]
⋮----
full_name = (full_name or "").strip()
⋮----
parts = full_name.split()
⋮----
def unique_username_from_name(name: str) -> str
⋮----
base = slugify(name or "coach") or "coach"
uname = base
i = 2
⋮----
uname = f"{base}-{i}"
⋮----
def get_or_create_user_by_name(teacher_name: str) -> User
⋮----
key = (teacher_name or "").strip().lower()
⋮----
user = (
⋮----
username = unique_username_from_name(teacher_name)
user = User.objects.create(
⋮----
def _digits(s: str) -> str
def parse_price(item: Dict[str, Any]) -> int
⋮----
raw = (item.get("price") or "").strip()
⋮----
raw = item.get("price_html") or ""
n = _digits(raw)
⋮----
val = int(n)
⋮----
def best_thumbnail(item: Dict[str, Any]) -> str
⋮----
default = (item.get("teacherPhotos") or {}).get("default") or {}
⋮----
def parse_duration_minutes(_: Dict[str, Any]) -> int
def compute_location(item: Dict[str, Any]) -> str
⋮----
city = (item.get("teacherCity") or "").strip()
f2f = bool(item.get("faceToFace"))
webcam = bool(item.get("webcam"))
⋮----
def safe_decimal(x: Any) -> Decimal
def normalize_superprof_payload(payload: Dict[str, Any]) -> List[Dict[str, Any]]
⋮----
rows: List[Dict[str, Any]] = []
⋮----
title = (it.get("title") or "").strip()[:200]
url_path = (it.get("url") or "").strip()
source_url = ("https://www.superprof.co.id" + url_path) if url_path.startswith("/") else url_path
flags = []
⋮----
dur = it.get("firstFreeDuration") or ""
⋮----
description = f"{title}\n\nSumber: {source_url}\n" + (" • ".join(flags) if flags else "")
teacher_avg = safe_decimal(((it.get("teacherRating") or {}).get("average")))
⋮----
@transaction.atomic
def ingest_rows(rows: List[Dict[str, Any]], category: Category) -> Tuple[int, int]
⋮----
coach_touched = 0
course_touched = 0
⋮----
user = get_or_create_user_by_name(row["coach_name"])
⋮----
def set_page_in_url(url: str, page: int) -> str
⋮----
parsed = urllib.parse.urlsplit(url)
q = dict(urllib.parse.parse_qsl(parsed.query, keep_blank_values=True))
⋮----
new_query = urllib.parse.urlencode(q, doseq=True)
⋮----
def fetch_json(url: str, session: requests.Session, sleep: float, max_retries: int) -> Dict[str, Any]
⋮----
last_error = None
⋮----
resp = session.get(url, headers=DEFAULT_HEADERS, cookies=DEFAULT_COOKIES, timeout=REQUEST_TIMEOUT)
⋮----
last_error = e
⋮----
def crawl_once(base_url: str, start_page: int, end_page: int | None, sleep: float, max_retries: int, category: Category) -> tuple[int, int]
⋮----
coaches_total = 0
courses_total = 0
⋮----
first_url = set_page_in_url(base_url, start_page)
payload = fetch_json(first_url, s, sleep, max_retries)
last = int(payload.get("nbPagesTotal") or payload.get("nb_pages_total") or (end_page or 1))
⋮----
end_page = last
rows = normalize_superprof_payload(payload)
⋮----
url = set_page_in_url(base_url, page)
payload = fetch_json(url, s, sleep, max_retries)
⋮----
class Command(BaseCommand)
⋮----
help = "Crawl Superprof JSON pages and ingest into Coach/Course for a given Category."
def add_arguments(self, parser)
def handle(self, *args, **opts)
⋮----
base_url = opts["url"]
category_name = opts["category"].strip()
category_thumb = opts.get("category_thumb")
category_desc = opts.get("category_desc")
start_page = int(opts["start_page"])
end_page = opts["end_page"]
sleep = float(opts["sleep"])
max_retries = int(opts["max_retries"])
repeat_every = opts["repeat_every"]
````

## File: main/templates/pages/landing_page/categories.html
````html
{% load static %}
<section class="relative py-20 bg-[#FFFAF5] overflow-hidden">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div class="text-center mb-16">
            <h2 class="text-4xl sm:text-5xl font-bold text-gray-900 mb-4">
                Temukan <span class="text-primary underline decoration-secondary">Olahraga Mu</span>
            </h2>
            <p class="text-lg text-gray-600 max-w-2xl mx-auto">
                Jelajahi berbagai kategori olahraga dan temukan kelas yang sesuai dengan minat dan tujuan Anda
            </p>
        </div>
        {% if categories %}
        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 lg:gap-6">
            {% for category in categories %}
            <a
                href="{% url 'courses_and_coach:category_detail' category.name %}"
                class="category-card group relative overflow-hidden rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2"
            >
                {% if category.thumbnail_url %}
                <img
                    src="{{ category.thumbnail_url }}"
                    alt="{{ category.name }}"
                    class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-500"
                />
                {% else %}
                <div class="w-full h-48 bg-gradient-to-br from-primary to-secondary flex items-center justify-center">
                    <svg class="w-20 h-20 text-white opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                    </svg>
                </div>
                {% endif %}
                <div class="absolute inset-0 bg-gradient-to-t from-black via-transparent to-transparent opacity-60 group-hover:opacity-75 transition-opacity duration-300"></div>
                <div class="absolute inset-0 flex flex-col justify-end p-4">
                    <h3 class="text-white font-bold text-lg mb-2 group-hover:translate-y-0 transition-transform duration-300">
                        {{ category.name }}
                    </h3>
                    {% if category.description %}
                    <p class="text-white text-xs opacity-0 group-hover:opacity-100 transition-opacity duration-300 line-clamp-2">
                        {{ category.description }}
                    </p>
                    {% endif %}
                </div>
                <div class="absolute top-4 right-4 bg-white bg-opacity-90 p-2 rounded-full group-hover:bg-primary group-hover:text-white transition-all duration-300 transform group-hover:rotate-45">
                    <svg class="w-5 h-5 text-primary group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
                    </svg>
                </div>
            </a>
            {% endfor %}
        </div>
        {% else %}
        <div class="text-center flex flex-col justify-center items-center gap-4 py-16 bg-gray-50 rounded-lg">
            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-book-dashed-icon lucide-book-dashed"><path d="M12 17h1.5"/><path d="M12 22h1.5"/><path d="M12 2h1.5"/><path d="M17.5 22H19a1 1 0 0 0 1-1"/><path d="M17.5 2H19a1 1 0 0 1 1 1v1.5"/><path d="M20 14v3h-2.5"/><path d="M20 8.5V10"/><path d="M4 10V8.5"/><path d="M4 19.5V14"/><path d="M4 4.5A2.5 2.5 0 0 1 6.5 2H8"/><path d="M8 22H6.5a1 1 0 0 1 0-5H8"/></svg>
            <p class="text-gray-600 text-lg">Belum ada kategori yang tersedia</p>
        </div>
        {% endif %}
    </div>
</section>
````

## File: main/templates/pages/landing_page/coach_section.html
````html
{% load static %}
<section class="py-20 bg-white relative overflow-hidden">
    <div class="absolute top-10 left-10">
        <div class="w-3 h-3 bg-green-400 rounded-full opacity-20"></div>
    </div>
    <div class="absolute bottom-10 right-10">
        <div class="w-5 h-5 bg-purple-400 rounded-full opacity-30"></div>
    </div>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
            <div class="relative">
                <div class="relative rounded-3xl overflow-hidden shadow-2xl transform rotate-3 hover:rotate-0 transition-transform duration-500">
                    <img
                        src="{% static 'images/group-yoga-class.jpg' %}"
                        alt="Group Yoga Class"
                        class="w-full h-96 object-cover"
                        onerror="this.src='https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'"
                    >
                    <div class="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent"></div>
                </div>
                <div class="absolute -bottom-4 -left-4 bg-white rounded-2xl p-4 shadow-xl">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 bg-primary rounded-full flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path>
                            </svg>
                        </div>
                        <div>
                            <p class="text-sm font-semibold text-gray-900">500+ Coach</p>
                            <p class="text-xs text-gray-600">Berpengalaman</p>
                        </div>
                    </div>
                </div>
                <div class="absolute -top-4 -right-4 bg-secondary rounded-2xl p-3 shadow-xl transform rotate-12">
                    <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                </div>
            </div>
            <div class="space-y-8">
                <div class="space-y-4">
                    <h2 class="text-4xl sm:text-5xl font-bold text-gray-900 leading-tight">
                        Akses Instan ke <span class="text-primary">Coach Terbaik</span> di Seluruh Indonesia.
                    </h2>
                    <p class="text-lg text-gray-600">
                        Cari Coach Tersertifikasi Sekarang
                    </p>
                </div>
                <a href="{% url 'courses_and_coach:show_courses' %}" class="bg-primary text-white inline-block px-6 py-3 rounded-2xl font-semibold hover:bg-green-600 transition-colors duration-200">
                    Daftar
                </a>
                <div class="grid grid-cols-2 gap-6">
                    <div class="text-center p-4">
                        <div class="text-3xl font-bold text-primary mb-2">100+</div>
                        <div class="text-sm text-gray-600">Coach Tersertifikasi</div>
                    </div>
                    <div class="text-center p-4">
                        <div class="text-3xl font-bold text-primary mb-2">100+</div>
                        <div class="text-sm text-gray-600">Kelas Tersedia</div>
                    </div>
                    <div class="text-center p-4">
                        <div class="text-3xl font-bold text-primary mb-2">50+</div>
                        <div class="text-sm text-gray-600">Kota di Indonesia</div>
                    </div>
                    <div class="text-center p-4">
                        <div class="text-3xl font-bold text-primary mb-2">100+</div>
                        <div class="text-sm text-gray-600">Trainee Terdaftar</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
````

## File: main/templates/pages/landing_page/featured.html
````html
{% load static %}
<section class="relative py-16 bg-gradient-to-br from-gray-50 via-white to-blue-50 overflow-hidden">
     <svg class="absolute top-10 left-0 w-48 h-48 opacity-5 animate-float z-0" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
        <path fill="#3B82F6" d="M42.9,-72.8C54.2,-62.6,58,-46.5,61.6,-31.3C65.2,-16,68.6,-2.7,66.1,9.2C63.6,21.2,55.3,31.4,46.5,42.2C37.6,53,28.2,64.5,16.4,69.6C4.5,74.7,-9.9,73.3,-23.7,69.1C-37.5,64.8,-50.6,57.7,-56.6,46.5C-62.6,35.3,-61.5,20,-60.1,5.6C-58.7,-8.7,-57,-23.1,-50.8,-35.2C-44.6,-47.3,-33.9,-57.1,-22.1,-65.1C-10.3,-73.1,2.5,-79.2,15.3,-80.3C28,-81.4,40.7,-77,42.9,-72.8Z" transform="translate(100 100)" />
    </svg>
    <svg class="absolute top-1/3 right-0 w-64 h-64 opacity-20 animate-float-reverse z-0" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
        <path fill="#10B981" d="M43.6,-70.2C57.8,-61.1,66.2,-46.4,66.5,-32.6C66.8,-18.7,59,-5.7,54.8,8.6C50.5,22.9,49.8,37.3,42.7,46.9C35.7,56.5,22.3,61.3,8.6,64.3C-5.1,67.3,-20.2,68.6,-32.8,64.4C-45.5,60.2,-55.8,50.5,-61.3,38.4C-66.8,26.3,-67.5,11.9,-64.2,-2.2C-60.9,-16.2,-53.5,-29.7,-44.2,-40.2C-34.9,-50.6,-23.7,-58,-11.3,-63.5C1.2,-69,12.5,-72.6,25.5,-71.7C38.4,-70.8,53,-65.4,43.6,-70.2Z" transform="translate(100 100)" />
    </svg>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div class="text-center mb-12">
            <h2 class="text-4xl sm:text-5xl font-bold text-gray-900 mb-4">Kelas Olahraga <span class="text-primary underline decoration-secondary">Paling Diminati</span></h2>
            <p class="text-lg text-gray-600">Temukan kelas-kelas terpopuler dari coach berpengalaman kami</p>
        </div>
        {% if featured_courses %}
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {% for course in featured_courses %}
            <div class="group">
                {% include "courses_and_coach/partials/course_card.html" with course=course %}
            </div>
            {% endfor %}
        </div>
        <div class="text-center mt-12">
            <a
                href="{% url 'courses_and_coach:show_courses' %}"
                class="inline-flex items-center gap-2 bg-gradient-to-r from-primary to-green-600 text-white px-8 py-3 rounded-2xl font-semibold hover:shadow-lg hover:-translate-y-1 transition-all duration-300 text-lg relative group"
            >
                <span class="absolute inset-0 bg-white opacity-0 group-hover:opacity-10 rounded-2xl transition-opacity duration-300"></span>
                <span class="relative">Lihat Selengkapnya</span>
                <svg class="w-5 h-5 relative group-hover:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
                </svg>
            </a>
        </div>
        {% else %}
        <div class="text-center flex flex-col justify-center items-center py-12 gap-4 bg-white rounded-lg shadow-sm border border-gray-100">
            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-circle-off-icon lucide-circle-off"><path d="m2 2 20 20"/><path d="M8.35 2.69A10 10 0 0 1 21.3 15.65"/><path d="M19.08 19.08A10 10 0 1 1 4.92 4.92"/></svg>
            <p class="text-gray-600 text-lg">Belum ada kelas yang tersedia saat ini.</p>
        </div>
        {% endif %}
    </div>
</section>
<style>
    @keyframes float {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        50% { transform: translateY(-20px) rotate(2deg); }
    }
    @keyframes float-reverse {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        50% { transform: translateY(-15px) rotate(-2deg); }
    }
    .animate-float {
        animation: float 6s ease-in-out infinite;
    }
    .animate-float-reverse {
        animation: float-reverse 7s ease-in-out infinite;
    }
</style>
````

## File: main/templates/pages/landing_page/hero.html
````html
{% load static %}
{% block content %}
<section class="bg-gradient-to-br from-green-50 to-blue-50 min-h-screen flex items-center relative overflow-hidden">
    <div class="absolute top-10 left-10">
        <div class="w-4 h-4 bg-primary rounded-full opacity-30"></div>
    </div>
    <div class="absolute top-32 right-20">
        <div class="w-3 h-3 bg-blue-400 rounded-full opacity-40"></div>
    </div>
    <div class="absolute bottom-40 left-20">
        <div class="w-6 h-6 bg-yellow-400 rounded-full opacity-25"></div>
    </div>
    <div class="absolute bottom-20 right-32">
        <div class="w-8 h-8 bg-purple-400 opacity-20 transform rotate-45"></div>
    </div>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div class="space-y-8">
                <div class="inline-flex items-center space-x-2 bg-white rounded-full px-4 py-2 shadow-sm">
                    <div class="w-2 h-2 bg-primary rounded-full animate-pulse"></div>
                    <span class="text-sm font-medium text-gray-700">Mulai Hidup Aktifmu Sekarang!</span>
                </div>
                <div class="space-y-4">
                    <h1 class="text-4xl sm:text-5xl lg:text-6xl font-bold text-gray-900 leading-tight">
                        Akses <span class="text-primary underline  decoration-secondary">100+</span> Kelas Olahraga dari Coach
                        <span class="text-primary underline  decoration-secondary">Terverifikasi</span>
                        di Seluruh Indonesia
                    </h1>
                    <p class="text-lg text-gray-600 max-w-lg">
                        Temukan gaya olahraga yang cocok buat kamu
                    </p>
                </div>
                <div class="relative max-w-md">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                    </div>
                    <form method="GET" action="{% url 'courses_and_coach:show_courses' %}#list-section">
                    <input
                        type="text"
                        name="search"
                        placeholder="Cari kelas..."
                        class="block w-full pl-12 pr-4 py-4 border border-gray-300 rounded-2xl leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-primary focus:border-primary text-sm shadow-sm"
                    >
                    </input>
                    </form>
                    <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                        <button class="bg-primary text-white p-2 rounded-xl hover:bg-green-600 transition-colors duration-200">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                            </svg>
                        </button>
                    </div>
                </div>
                <div class="flex flex-col sm:flex-row gap-4">
                    <a href="{% url 'courses_and_coach:show_courses' %}" class="bg-primary text-white px-8 py-4 rounded-2xl font-semibold hover:bg-green-600 transition-colors duration-200 text-center">
                        Mulai Sekarang
                    </a>
                    <a href="{% url 'courses_and_coach:show_courses' %}" class="border-2 border-gray-300 text-gray-700 px-8 py-4 rounded-2xl font-semibold hover:border-primary hover:text-primary transition-colors duration-200 text-center">
                        Jelajahi Kelas
                    </a>
                </div>
            </div>
            <div class="relative">
                <div class="relative h-[500px] w-full">
                    <div class="absolute top-0 left-0 w-64 h-80 transform -rotate-6 hover:rotate-0 transition-transform duration-300">
                        <div class="bg-white p-3 rounded-2xl shadow-2xl h-full">
                            <img
                                src="{% static 'images/hero-plank.jpg' %}"
                                alt="Plank Exercise"
                                class="w-full h-full object-cover rounded-xl"
                                onerror="this.src='https://images.unsplash.com/photo-1518611012118-696072aa579a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'"
                            >
                        </div>
                    </div>
                    <div class="absolute top-16 right-0 w-64 h-80 transform rotate-6 hover:rotate-0 transition-transform duration-300">
                        <div class="bg-white p-3 rounded-2xl shadow-2xl h-full">
                            <img
                                src="{% static 'images/hero-yoga.jpg' %}"
                                alt="Yoga Training Session"
                                class="w-full h-full object-cover rounded-xl"
                                onerror="this.src='https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'"
                            >
                        </div>
                    </div>
                    <div class="absolute top-32 left-1/2 transform -translate-x-1/2 rotate-2 hover:rotate-0 transition-transform duration-300 w-56 h-72">
                        <div class="bg-white p-3 rounded-2xl shadow-2xl h-full">
                            <img
                                src="{% static 'images/hero-fitness.jpg' %}"
                                alt="Fitness Training"
                                class="w-full h-full object-cover rounded-xl"
                                onerror="this.src='https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'"
                            >
                        </div>
                    </div>
                </div>
                    <div class="absolute top-6 right-6 bg-white rounded-2xl p-4 shadow-lg">
                        <div class="flex items-center space-x-2">
                            <div class="flex items-center">
                                <svg class="w-5 h-5 text-primary fill-current" viewBox="0 0 20 20">
                                    <path d="M10 15l-5.878 3.09 1.123-6.545L.489 6.91l6.572-.955L10 0l2.939 5.955 6.572.955-4.756 4.635 1.123 6.545z"/>
                                </svg>
                                <span class="ml-1 font-bold text-gray-900">5.0</span>
                            </div>
                            <span class="text-sm text-gray-600">Rating</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
{% endblock %}
````

## File: main/templates/pages/landing_page/index.html
````html
{% extends "base.html" %}
{% load static %}
{% block title %}MamiCoach - Platform Coach Terbaik Indonesia{% endblock %}
{% block content %}
{% include 'pages/landing_page/hero.html' %}
{% include 'pages/landing_page/featured.html' %}
{% include 'pages/landing_page/categories.html' %}
{% include 'pages/landing_page/top_coaches.html' %}
{% include 'pages/landing_page/testimonials.html' %}
{% include 'pages/landing_page/coach_section.html' %}
{% endblock %}
````

## File: main/templates/pages/landing_page/testimonials.html
````html
<section class="py-16 bg-gradient-to-br from-green-50 to-blue-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
            <h2 class="text-3xl sm:text-4xl font-bold text-gray-900 mb-3">
                Baca <span class="text-primary underline decoration-secondary">Ulasannya!</span>
            </h2>
            <p class="text-lg text-gray-500">
                Keputusan Anda, Didukung Bukti Nyata.
            </p>
        </div>
        <div class="relative">
            {% if top_reviews %}
            <div class="flex items-center gap-2 md:gap-6">
                <button id="scroll-left" class="flex-shrink-0 cursor-pointer bg-primary text-white rounded-full p-2 md:p-3 hover:bg-green-600 transition-colors shadow-lg z-10" aria-label="Previous testimonials">
                    <svg class="h-5 w-5 md:h-6 md:w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                    </svg>
                </button>
                <div class="flex-1 overflow-hidden relative">
                    <div class="absolute left-0 top-0 bottom-0 w-12 md:w-24 bg-gradient-to-r from-gray-50 to-transparent z-5 pointer-events-none"></div>
                    <div class="flex gap-4 md:gap-6 overflow-x-auto snap-x snap-mandatory" id="testimonials-container" style="scroll-behavior: smooth; scrollbar-width: none; -ms-overflow-style: none;">
                        <div class="flex-shrink-0 w-8 md:w-16"></div>
                        {% for review in top_reviews %}
                        <div class="flex-shrink-0 w-full sm:w-1/2 lg:w-1/3 snap-start">
                            {% include 'partials/_review_card_styled.html' with review=review %}
                        </div>
                        {% endfor %}
                        <div class="flex-shrink-0 w-8 md:w-16"></div>
                    </div>
                    <div class="absolute right-0 top-0 bottom-0 w-12 md:w-24 bg-gradient-to-l from-gray-50 to-transparent z-5 pointer-events-none"></div>
                </div>
                <button id="scroll-right" class="flex-shrink-0 cursor-pointer  bg-primary text-white rounded-full p-2 md:p-3 hover:bg-green-600 transition-colors shadow-lg z-10" aria-label="Next testimonials">
                    <svg class="h-5 w-5 md:h-6 md:w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                    </svg>
                </button>
            </div>
            <div class="flex justify-center gap-2 md:gap-3 mt-6 md:mt-8">
                {% for review in top_reviews %}
                <button class="testimonial-dot w-2 h-2 md:w-3 md:h-3 rounded-full cursor-pointer transition-transform bg-gray-300 hover:bg-primary" data-index="{{ forloop.counter0 }}" aria-label="Go to testimonial {{ forloop.counter }}"></button>
                {% endfor %}
            </div>
            {% else %}
            <div class="text-center flex flex-col justify-center items-center py-12">
                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-panel-top-dashed-icon lucide-panel-top-dashed"><rect width="18" height="18" x="3" y="3" rx="2"/><path d="M14 9h1"/><path d="M19 9h2"/><path d="M3 9h2"/><path d="M9 9h1"/></svg>
                <p class="text-gray-500 text-lg">Belum ada ulasan tersedia</p>
            </div>
            {% endif %}
        </div>
    </div>
    <script>
        const container = document.getElementById('testimonials-container');
        const leftBtn = document.getElementById('scroll-left');
        const rightBtn = document.getElementById('scroll-right');
        const dots = document.querySelectorAll('.testimonial-dot');
        if (container) {
            // Calculate responsive values
            function getScrollValues() {
                // Get actual review cards (skip padding divs - they are empty)
                const allDivs = Array.from(container.querySelectorAll('div'));
                const reviewCards = allDivs.filter(div => div.querySelector('[class*="review"]') || div.innerHTML.trim() !== '');
                if (reviewCards.length === 0) return { cardWidth: 0, cardsPerPage: 1, pageWidth: 0 };
                const firstCard = reviewCards[0];
                const gap = parseFloat(window.getComputedStyle(container).gap) || 16;
                const cardWidth = firstCard.offsetWidth + gap;
                // Determine cards per page based on screen width
                let cardsPerPage = 1;
                if (window.innerWidth >= 640) { // sm
                    cardsPerPage = 2;
                }
                if (window.innerWidth >= 1024) { // lg
                    cardsPerPage = 3;
                }
                return {
                    cardWidth: cardWidth,
                    cardsPerPage: cardsPerPage,
                    pageWidth: cardWidth * cardsPerPage
                };
            }
            function updateDots() {
                const { cardWidth } = getScrollValues();
                const scrollLeft = container.scrollLeft;
                // Account for initial padding
                const paddingDiv = container.querySelector('div:first-child');
                const initialPadding = paddingDiv ? paddingDiv.offsetWidth : 0;
                // Adjust scroll position by subtracting padding, then calculate index
                const adjustedScroll = Math.max(0, scrollLeft - initialPadding);
                const activeIndex = Math.round(adjustedScroll / cardWidth);
                // Clamp to valid range
                const validIndex = Math.min(activeIndex, dots.length - 1);
                dots.forEach((dot, index) => {
                    dot.classList.toggle('bg-primary', index === validIndex);
                    dot.classList.toggle('scale-125', index === validIndex);
                    dot.classList.toggle('bg-gray-300', index !== validIndex);
                    dot.classList.toggle('scale-100', index !== validIndex);
                });
            }
            leftBtn.addEventListener('click', () => {
                const { pageWidth } = getScrollValues();
                container.scrollBy({ left: -pageWidth, behavior: 'smooth' });
                setTimeout(updateDots, 150);
            });
            rightBtn.addEventListener('click', () => {
                const { pageWidth } = getScrollValues();
                container.scrollBy({ left: pageWidth, behavior: 'smooth' });
                setTimeout(updateDots, 150);
            });
            dots.forEach((dot, index) => {
                dot.addEventListener('click', () => {
                    const { cardWidth } = getScrollValues();
                    const paddingDiv = container.querySelector('div:first-child');
                    const initialPadding = paddingDiv ? paddingDiv.offsetWidth : 0;
                    const gap = parseFloat(window.getComputedStyle(container).gap) || 16;
                    container.scrollTo({ left: initialPadding + cardWidth * index, behavior: 'smooth' });
                    setTimeout(updateDots, 150);
                });
            });
            // Handle scroll event for continuous dot updates
            let scrollTimeout;
            container.addEventListener('scroll', () => {
                clearTimeout(scrollTimeout);
                scrollTimeout = setTimeout(updateDots, 50);
            });
            // Update on window resize
            window.addEventListener('resize', () => {
                updateDots();
            });
            // Initial update
            setTimeout(updateDots, 100);
        }
    </script>
    <style>
        #testimonials-container::-webkit-scrollbar {
            display: none;
        }
    </style>
</section>
````

## File: main/templates/pages/landing_page/top_coaches.html
````html
{% load static %}
<section class="relative py-20 bg-gradient-to-br from-gray-50 via-white to-blue-50 overflow-hidden">
     <svg class="absolute top-10 right-0 w-48 h-48 opacity-5 animate-float z-0" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
        <path fill="#f6923bff" d="M42.9,-72.8C54.2,-62.6,58,-46.5,61.6,-31.3C65.2,-16,68.6,-2.7,66.1,9.2C63.6,21.2,55.3,31.4,46.5,42.2C37.6,53,28.2,64.5,16.4,69.6C4.5,74.7,-9.9,73.3,-23.7,69.1C-37.5,64.8,-50.6,57.7,-56.6,46.5C-62.6,35.3,-61.5,20,-60.1,5.6C-58.7,-8.7,-57,-23.1,-50.8,-35.2C-44.6,-47.3,-33.9,-57.1,-22.1,-65.1C-10.3,-73.1,2.5,-79.2,15.3,-80.3C28,-81.4,40.7,-77,42.9,-72.8Z" transform="translate(100 100)" />
    </svg>
    <svg class="absolute bottom-10 left-0 w-64 h-64 opacity-20 animate-float-reverse z-0" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
        <path fill="#c82eaeff" d="M43.6,-70.2C57.8,-61.1,66.2,-46.4,66.5,-32.6C66.8,-18.7,59,-5.7,54.8,8.6C50.5,22.9,49.8,37.3,42.7,46.9C35.7,56.5,22.3,61.3,8.6,64.3C-5.1,67.3,-20.2,68.6,-32.8,64.4C-45.5,60.2,-55.8,50.5,-61.3,38.4C-66.8,26.3,-67.5,11.9,-64.2,-2.2C-60.9,-16.2,-53.5,-29.7,-44.2,-40.2C-34.9,-50.6,-23.7,-58,-11.3,-63.5C1.2,-69,12.5,-72.6,25.5,-71.7C38.4,-70.8,53,-65.4,43.6,-70.2Z" transform="translate(100 100)" />
    </svg>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-16">
            <div class="flex-1">
                <h2 class="text-4xl sm:text-5xl font-bold text-gray-900 mb-4">
                    Coach <span class="text-primary underline decoration-secondary">Terbaik Kami</span>
                </h2>
                <p class="text-lg text-gray-600 max-w-2xl">
                    Pelajari dari coach berpengalaman dan tersertifikasi yang siap membantu Anda mencapai tujuan fitness
                </p>
            </div>
            <a
                href="{% url 'courses_and_coach:show_coaches' %}"
                class="mt-6 md:mt-0 inline-flex items-center gap-2 bg-primary hover:bg-green-700 text-white px-6 py-3 rounded-2xl font-semibold transition-all duration-300 hover:shadow-lg hover:-translate-y-1 group whitespace-nowrap"
            >
                <span>Lihat Semua Coach</span>
                <svg class="w-5 h-5 group-hover:translate-x-1 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
                </svg>
            </a>
        </div>
        {% if top_coaches %}
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {% for coach in top_coaches %}
            {% include "courses_and_coach/partials/coach_card.html" with coach=coach %}
            {% endfor %}
        </div>
        {% else %}
        <div class="text-center flex flex-col justify-center items-center gap-4 py-16 bg-white rounded-2xl shadow-lg">
            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-user-round-x-icon lucide-user-round-x"><path d="M2 21a8 8 0 0 1 11.873-7"/><circle cx="10" cy="8" r="5"/><path d="m17 17 5 5"/><path d="m22 17-5 5"/></svg>
            <p class="text-gray-600 text-lg">Belum ada coach yang tersedia</p>
        </div>
        {% endif %}
    </div>
</section>
````

## File: main/templates/pages/main.html
````html
{% extends "base.html" %}
{% load static %}
{% block title %}MamiCoach - Platform Coach Terbaik Indonesia{% endblock %}
{% block content %}
{% include 'pages/landing_page/hero.html' %}
{% include 'pages/landing_page/coach_section.html' %}
{% endblock %}
````

## File: main/templates/partials/_footer.html
````html
{% load static %}
<footer class="bg-white border-t border-gray-200 mt-auto ">
    <div class="max-w-7xl mx-auto px-12 sm:px-6 lg:px-8 py-12">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 md:justify-items-center">
            <div>
                <div class="flex items-center mb-6">
                    <img src="{% static 'images/logo.png' %}" alt="MamiCoach Logo" class="h-10 w-10 mr-3">
                    <span class="text-xl font-bold text-primary">mamicoach</span>
                </div>
                <h3 class="text-lg font-semibold text-gray-900 mb-4">
                    Contact Us
                </h3>
                <div class="space-y-3">
                    <p class="text-sm text-gray-600">
                        <span class="font-medium">Call:</span> +62 800 125
                    </p>
                    <p class="text-sm text-gray-600">
                        Saatnya Transformasi. Saatnya<br>
                        MamiCoach.
                    </p>
                </div>
                <div class="flex space-x-3 mt-6">
                    <a href="#" class="w-8 h-8 bg-gray-100 rounded-full flex items-center justify-center text-gray-600 hover:bg-primary hover:text-white transition-colors duration-200 p-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-facebook-icon lucide-facebook"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
                    </a>
                    <a href="#" class="w-8 h-8 bg-gray-100 rounded-full flex items-center justify-center text-gray-600 hover:bg-primary hover:text-white transition-colors duration-200 p-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-twitter-icon lucide-twitter"><path d="M22 4s-.7 2.1-2 3.4c1.6 10-9.4 17.3-18 11.6 2.2.1 4.4-.6 6-2C3 15.5.5 9.6 3 5c2.2 2.6 5.6 4.1 9 4-.9-4.2 4-6.6 7-3.8 1.1 0 3-1.2 3-1.2z"/></svg>
                    </a>
                    <a href="#" class="w-8 h-8 bg-gray-100 rounded-full flex items-center justify-center text-gray-600 hover:bg-primary hover:text-white transition-colors duration-200 p-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-instagram-icon lucide-instagram"><rect width="20" height="20" x="2" y="2" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" x2="17.51" y1="6.5" y2="6.5"/></svg>
                    </a>
                </div>
            </div>
            <div>
                <h3 class="text-lg font-semibold text-gray-900 mb-4">
                    Explore
                </h3>
                <ul class="space-y-3">
                    <li>
                        <a href="/" class="text-sm text-gray-600 hover:text-primary transition-colors duration-200">
                            Beranda
                        </a>
                    </li>
                    <li>
                        <a href="#" class="text-sm text-gray-600 hover:text-primary transition-colors duration-200">
                            Cari Kelas
                        </a>
                    </li>
                    <li>
                        <a href="#" class="text-sm text-gray-600 hover:text-primary transition-colors duration-200">
                            Coach
                        </a>
                    </li>
                    <li>
                        <a href="#" class="text-sm text-gray-600 hover:text-primary transition-colors duration-200">
                            Bergabung Jadi Coach
                        </a>
                    </li>
                </ul>
            </div>
            <div>
                <h3 class="text-lg font-semibold text-gray-900 mb-4">
                    Category
                </h3>
                <ul class="space-y-3">
                    <li>
                        <a href="#" class="text-sm text-gray-600 hover:text-primary transition-colors duration-200">
                            Design
                        </a>
                    </li>
                    <li>
                        <a href="#" class="text-sm text-gray-600 hover:text-primary transition-colors duration-200">
                            Development
                        </a>
                    </li>
                    <li>
                        <a href="#" class="text-sm text-gray-600 hover:text-primary transition-colors duration-200">
                            Marketing
                        </a>
                    </li>
                    <li>
                        <a href="#" class="text-sm text-gray-600 hover:text-primary transition-colors duration-200">
                            Business
                        </a>
                    </li>
                    <li>
                        <a href="#" class="text-sm text-gray-600 hover:text-primary transition-colors duration-200">
                            Lifestyle
                        </a>
                    </li>
                    <li>
                        <a href="#" class="text-sm text-gray-600 hover:text-primary transition-colors duration-200">
                            Photography
                        </a>
                    </li>
                    <li>
                        <a href="#" class="text-sm text-gray-600 hover:text-primary transition-colors duration-200">
                            Music
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</footer>
````

## File: main/templates/partials/_navbar.html
````html
{% load static %}
<nav class="bg-white shadow-sm border-b border-gray-200 sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-2">
        <div class="flex justify-around items-center h-16">
            <div class="flex items-center">
                <a href="/" class="flex items-center space-x-2">
                    <img src="{% static 'images/logo.png' %}" alt="mamicoach Logo" class="h-8 w-8">
                    <span class="text-2xl font-bold text-primary">mamicoach</span>
                </a>
            </div>
            <div class="hidden lg:flex flex-1 max-w-md mx-8">
                <form method="GET" action="{% url 'courses_and_coach:show_courses' %}#list-section" class="relative w-full">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                    </div>
                    <input type="text"
                            name="search"
                           placeholder="Cari kelas..."
                           class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-primary focus:border-primary text-sm">
                </form>
            </div>
            <div class="hidden md:flex items-center space-x-2 lg:space-x-6">
                <a href="/" class="text-gray-700 hover:text-primary px-3 py-2 text-sm font-medium transition-colors duration-200">
                    Beranda
                </a>
                <a href="{% url 'courses_and_coach:show_courses' %}" class="text-gray-700 hover:text-primary px-3 py-2 text-sm font-medium transition-colors duration-200">
                    Kelas
                </a>
                <a href="{% url 'courses_and_coach:show_coaches' %}" class="text-gray-700 hover:text-primary px-3 py-2 text-sm font-medium transition-colors duration-200">
                    Coach
                </a>
                {% if user.coachprofile %}
                <a href="{% url 'user_profile:dashboard_coach' %}" class="text-gray-700 hover:text-primary px-3 py-2 text-sm font-medium transition-colors duration-200 ">
                    Dashboard
                </a>
                <a href="{% url 'courses_and_coach:create_course' %}" class="text-gray-700 hover:text-primary px-3 py-2 text-sm font-medium transition-colors duration-200 ">
                Buat Kelas
                </a>
                {% elif user.is_authenticated %}
                <a href="{% url 'user_profile:dashboard_user' %}" class="text-gray-700 hover:text-primary px-3 py-2 text-sm font-medium transition-colors duration-200 ">
                    Dashboard
                </a>
                {% else %}
                <a href="{% url 'user_profile:register_coach' %}" class="text-gray-700 hover:text-primary px-3 py-2 text-sm font-medium transition-colors duration-200 ">
                Bergabung Jadi Coach
                </a>
                {% endif %}
            </div>
            <div class="hidden md:flex items-center space-x-3 ml-6">
                {% if user.is_authenticated %}
                    <div class="relative group">
                        <button class="flex items-center space-x-2 text-gray-700 hover:text-primary focus:outline-none">
                            <div class="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center">
                               <img
                                     src="{% if user.coachprofile and user.coachprofile.image_url %}{{ user.coachprofile.image_url }}{% elif user.userprofile and user.userprofile.image_url %}{{ user.userprofile.image_url }}{% endif %}"
                                     alt="Profile Picture"
                                     class="w-8 h-8 rounded-full object-cover"
                                >
                            </div>
                            <span class="text-sm font-medium">{{ user.first_name|default:user.username }}</span>
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                            </svg>
                        </button>
                        <div class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 border border-gray-200 z-50">
                            {% if user.coachprofile %}
                                <a href="{% url 'courses_and_coach:my_courses' %}" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                    Kelas Saya
                                </a>
                                <a href="{% url 'user_profile:dashboard_coach' %}" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                    Dashboard
                                </a>
                                <a href="{% url 'courses_and_coach:create_course' %}" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                    Buat Kelas
                                </a>
                                <a href="{% url 'courses_and_coach:create_course' %}" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                    Buat Kelas Baru
                                </a>
                            {% else %}
                                <a href="{% url 'user_profile:dashboard_user' %}" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                    Dashboard
                                </a>
                            {% endif %}
                            <div class="border-t border-gray-100"></div>
                            <a href="{% url 'user_profile:logout' %}" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 logout-btn">
                                Keluar
                            </a>
                        </div>
                    </div>
                {% else %}
                    <button id="openLoginModal" class="text-gray-700 hover:text-primary px-3 py-2 text-sm font-medium transition-colors duration-200">
                        Masuk
                    </button>
                    <a href="{% url 'user_profile:register' %}" class="bg-primary text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-green-600 transition-colors duration-200">
                        Mulai Sekarang
                    </a>
                {% endif %}
            </div>
            {% if user.is_authenticated %}
            <div class="ml-4 max-md:hidden">
                <a href="{% url 'chat:chat_index' %}" class="text-gray-700 hover:text-primary p-2 relative">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.25" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-inbox-icon lucide-inbox"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"/></svg>
                </a>
            </div>
            {% endif %}
            <div class="md:hidden">
                <button id="mobile-menu-button" class="text-gray-700 hover:text-primary focus:outline-none focus:text-primary p-2">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                    </svg>
                </button>
            </div>
        </div>
        <div class="lg:hidden px-4 pb-3 z-30">
            <form method="GET" action="{% url 'courses_and_coach:show_courses' %}#list-section" class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                    </svg>
                </div>
                <input type="text"
                        name="search"
                       placeholder="Cari kelas..."
                       class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-primary focus:border-primary text-sm z-40">
            </form>
        </div>
    </div>
    <div id="mobile-menu" class="md:hidden hidden bg-white border-t border-gray-200 z-50">
        <div class="px-2 pt-2 pb-3 space-y-1">
            <a href="/" class="block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium">
                Beranda
            </a>
            <a href="{% url 'courses_and_coach:show_courses' %}" class="block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium">
                Kelas
            </a>
            <a href="{% url 'courses_and_coach:show_coaches' %}" class="block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium">
                Coach
            </a>
            {% if user.is_authenticated %}
                <div class="border-t border-gray-200 pt-4">
                    <div class="flex items-center px-3 py-2">
                        <div class="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center">
                            <span class="text-gray-600 font-medium text-sm">
                                {{ user.first_name|first|default:user.username|first|upper }}
                            </span>
                        </div>
                        <span class="ml-3 text-base font-medium text-gray-800">{{ user.first_name|default:user.username }}</span>
                    </div>
                    {% if user.coachprofile %}
                        <a href="{% url 'courses_and_coach:my_courses' %}" class="block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium">
                            Kelas Saya
                        </a>
                        <a href="{% url 'user_profile:dashboard_coach' %}" class="block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium">
                            Dashboard
                        </a>
                        <a href="{% url 'courses_and_coach:create_course' %}" class="block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium">
                            Buat Kelas Baru
                        </a>
                    {% elif user.is_authenticated %}
                        <a href="{% url 'chat:chat_index' %}" class="block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium">
                            Pesan Saya
                        </a>
                        <a href="{% url 'user_profile:dashboard_user' %}" class="block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium">
                            Dashboard
                        </a>
                    {% else %}
                        <a href="{% url 'user_profile:register_coach' %}" class="block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium">
                            Bergabung Jadi Coach
                        </a>
                    {% endif %}
                    <a href="{% url 'user_profile:logout' %}" class="block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium logout-btn">
                        Keluar
                    </a>
                </div>
            {% else %}
                <a href="{% url 'user_profile:register_coach' %}" class="block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium">
                    Bergabung Jadi Coach
                </a>
                <div class="border-t border-gray-200 pt-4 space-y-1">
                    <button id="openLoginModalMobile" class="w-full text-left block px-3 py-2 text-gray-700 hover:text-primary hover:bg-gray-50 rounded-md text-base font-medium">
                        Masuk
                    </button>
                    <a href="{% url 'user_profile:register' %}" class="block px-3 py-2 bg-primary text-white hover:bg-green-600 rounded-md text-base font-medium text-center">
                        Mulai Sekarang
                    </a>
                </div>
            {% endif %}
        </div>
    </div>
</nav>
<div id="loginModal" class="fixed inset-0 z-[60] hidden justify-center items-center p-4" style="display: none; background-color: rgba(0, 0, 0, 0.25);">
    <div class="bg-white rounded-2xl shadow-2xl max-w-md w-full relative overflow-hidden" id="loginModalContent" style="transform: scale(0.95); opacity: 0; transition: all 0.3s ease; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2);">
        <button type="button" id="closeLoginModal" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 transition-colors z-10">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
            </svg>
        </button>
        <div class="p-8 pb-6">
            <div class="text-center mb-6">
                <div class="flex justify-center mb-4">
                    <img src="{% static 'images/logo.png' %}" alt="MamiCoach Logo" class="h-16 w-auto">
                </div>
                <h2 class="text-3xl font-bold text-gray-800 mb-2">Selamat Datang</h2>
                <p class="text-gray-500">Masuk ke akun MamiCoach Anda</p>
            </div>
            <form method="POST" action="{% url 'user_profile:login' %}" id="loginForm">
                {% csrf_token %}
                <input type="hidden" name="from_modal" value="true">
                {% if messages %}
                <div class="mb-4">
                    {% for message in messages %}
                    <div class="bg-red-50 border-l-4 border-red-500 rounded-lg p-3">
                        <p class="text-red-800 text-sm font-medium">{{ message }}</p>
                    </div>
                    {% endfor %}
                </div>
                {% endif %}
                <div class="mb-4">
                    <label for="id_username_modal" class="block text-sm font-medium text-gray-700 mb-2">Username</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                            </svg>
                        </div>
                        <input type="text"
                               name="username"
                               id="id_username_modal"
                               class="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-200 text-sm"
                               placeholder="Masukkan username Anda"
                               required>
                    </div>
                </div>
                <div class="mb-6">
                    <label for="id_password_modal" class="block text-sm font-medium text-gray-700 mb-2">Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                            </svg>
                        </div>
                        <input type="password"
                               name="password"
                               id="id_password_modal"
                               class="block w-full pl-10 pr-10 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-200 text-sm"
                               placeholder="Masukkan password Anda"
                               required>
                        <button type="button" id="togglePassword" class="absolute inset-y-0 right-0 pr-3 flex items-center">
                            <svg id="eyeIcon" class="h-5 w-5 text-gray-400 hover:text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                            </svg>
                        </button>
                    </div>
                </div>
                <button type="submit"
                        class="w-full bg-gradient-to-r from-green-500 to-green-600 text-white py-3 rounded-lg font-semibold hover:from-green-600 hover:to-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 transform transition-all duration-200 hover:scale-[1.02] active:scale-[0.98]">
                    Masuk
                </button>
            </form>
        </div>
        <div class="bg-gray-50 px-8 py-6 rounded-b-2xl">
            <p class="text-center text-sm text-gray-600 mb-3">Belum punya akun?</p>
            <div class="flex gap-3">
                <a href="{% url 'user_profile:register' %}"
                   class="flex-1 text-center px-4 py-2.5 border-2 rounded-lg font-medium transition-all duration-200"
                   style="border-color: #35A753; color: #35A753;"
                   onmouseover="this.style.backgroundColor='#35A753'; this.style.color='white';"
                   onmouseout="this.style.backgroundColor='transparent'; this.style.color='#35A753';">
                    Daftar sebagai Trainee
                </a>
                <a href="{% url 'user_profile:register_coach' %}"
                   class="flex-1 text-center px-4 py-2.5 border-2 rounded-lg font-medium transition-all duration-200"
                   style="border-color: #35A753; color: #35A753;"
                   onmouseover="this.style.backgroundColor='#35A753'; this.style.color='white';"
                   onmouseout="this.style.backgroundColor='transparent'; this.style.color='#35A753';">
                    Daftar sebagai Coach
                </a>
            </div>
        </div>
    </div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    const mobileMenu = document.getElementById('mobile-menu');
    if (mobileMenuButton && mobileMenu) {
        mobileMenuButton.addEventListener('click', function() {
            mobileMenu.classList.toggle('hidden');
        });
    }
    // Login Modal functionality
    const loginModal = document.getElementById('loginModal');
    const loginModalContent = document.getElementById('loginModalContent');
    const openLoginModalBtn = document.getElementById('openLoginModal');
    const openLoginModalMobileBtn = document.getElementById('openLoginModalMobile');
    const closeLoginModalBtn = document.getElementById('closeLoginModal');
    const togglePasswordBtn = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('id_password_modal');
    const eyeIcon = document.getElementById('eyeIcon');
    // Open modal
    function openModal() {
        loginModal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
        setTimeout(() => {
            loginModalContent.style.transform = 'scale(1)';
            loginModalContent.style.opacity = '1';
        }, 10);
    }
    // Close modal
    function closeModal() {
        loginModalContent.style.transform = 'scale(0.95)';
        loginModalContent.style.opacity = '0';
        setTimeout(() => {
            loginModal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }, 300);
    }
    // Event listeners
    if (openLoginModalBtn) {
        openLoginModalBtn.addEventListener('click', function(e) {
            e.preventDefault();
            openModal();
        });
    }
    if (openLoginModalMobileBtn) {
        openLoginModalMobileBtn.addEventListener('click', function(e) {
            e.preventDefault();
            if (mobileMenu) {
                mobileMenu.classList.add('hidden');
            }
            openModal();
        });
    }
    if (closeLoginModalBtn) {
        closeLoginModalBtn.addEventListener('click', function(e) {
            e.preventDefault();
            closeModal();
        });
    }
    // Close modal when clicking outside
    if (loginModal) {
        loginModal.addEventListener('click', function(e) {
            if (e.target === loginModal) {
                closeModal();
            }
        });
    }
    // Close modal on ESC key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && loginModal.style.display === 'flex') {
            closeModal();
        }
    });
    if (togglePasswordBtn && passwordInput) {
        togglePasswordBtn.addEventListener('click', function(e) {
            e.preventDefault();
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            if (type === 'text') {
                eyeIcon.innerHTML = `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"></path>`;
            } else {
                eyeIcon.innerHTML = `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>`;
            }
        });
    }
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('login_error') === '1') {
        openModal();
        const newUrl = window.location.pathname + window.location.search.replace(/[?&]login_error=1/, '').replace(/^&/, '?');
        window.history.replaceState({}, '', newUrl || window.location.pathname);
    }
    // AJAX Login Form Submission
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(loginForm);
            const submitBtn = loginForm.querySelector('button[type="submit"]');
            const originalBtnText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.style.opacity = '0.7';
            submitBtn.style.cursor = 'not-allowed';
            submitBtn.textContent = 'Loading...';
            fetch(loginForm.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    closeModal();
                    setTimeout(() => {
                        window.location.href = data.redirect_url;
                    }, 1000);
                } else {
                    showToast(data.message, 'error');
                    submitBtn.disabled = false;
                    submitBtn.style.opacity = '1';
                    submitBtn.style.cursor = 'pointer';
                    submitBtn.innerHTML = originalBtnText;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('An error occurred. Please try again.', 'error');
                submitBtn.disabled = false;
                submitBtn.style.opacity = '1';
                submitBtn.style.cursor = 'pointer';
                submitBtn.innerHTML = originalBtnText;
            });
        });
    }
    // AJAX Logout
    const logoutBtns = document.querySelectorAll('.logout-btn');
    logoutBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const logoutUrl = this.href;
            fetch(logoutUrl, {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'info');
                    setTimeout(() => {
                        window.location.href = data.redirect_url;
                    }, 1000);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                window.location.href = logoutUrl;
            });
        });
    });
});
</script>
````

## File: main/templates/404.html
````html
{% extends "base.html" %}
{% load static %}
{% block title %}Halaman Tidak Ditemukan - MamiCoach{% endblock %}
{% block content %}
<div class="min-h-screen bg-gray-50 flex items-center justify-center px-4 py-8">
    <div class="max-w-5xl w-full flex flex-col md:flex-row items-center gap-12">
        <div class="flex-shrink-0">
            <img
                src="{% static 'images/404.png' %}"
                alt="404 Not Found"
                class="w-64 h-64 md:w-80 md:h-80 object-contain"
            >
        </div>
        <div class="flex-1 text-center md:text-left">
            <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">Halaman Tidak Ditemukan</h1>
            <p class="text-lg text-gray-600 mb-8">
                Maaf, halaman yang Anda cari tidak ada atau telah dipindahkan.
            </p>
            <div class="flex flex-col sm:flex-row gap-4 md:justify-start justify-center">
                <a
                    href="/"
                    class="inline-flex items-center justify-center gap-2 bg-primary text-white px-6 py-3 rounded-2xl font-semibold hover:bg-green-700 transition-colors duration-300"
                >
                    Kembali ke Beranda
                </a>
                <a
                    href="/courses/"
                    class="inline-flex items-center justify-center gap-2 bg-gray-300 text-gray-900 px-6 py-3 rounded-2xl font-semibold hover:bg-gray-400 transition-colors duration-300"
                >
                    Jelajahi Kelas
                </a>
            </div>
        </div>
    </div>
</div>
{% endblock %}
````

## File: main/templates/500.html
````html
{% extends "base.html" %}
{% load static %}
{% block title %}Kesalahan Server - MamiCoach{% endblock %}
{% block content %}
<div class="min-h-screen bg-red-50 flex items-center justify-center px-4 py-8">
    <div class="max-w-5xl w-full flex flex-col md:flex-row-reverse items-center gap-12">
        <div class="flex-shrink-0">
            <img
                src="{% static 'images/500.png' %}"
                alt="500 Internal Server Error"
                class="w-64 h-64 md:w-96 md:h-96 object-contain"
            >
        </div>
        <div class="flex-1 text-center md:text-left">
            <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">Kesalahan Server</h1>
            <p class="text-lg text-gray-600 mb-8">
                Maaf, terjadi kesalahan pada server kami. Silakan coba lagi nanti.
            </p>
            <div class="flex flex-col sm:flex-row gap-4 md:justify-start justify-center">
                <a
                    href="/"
                    class="inline-flex items-center justify-center gap-2 bg-primary text-white px-6 py-3 rounded-2xl font-semibold hover:bg-green-700 transition-colors duration-300"
                >
                    Kembali ke Beranda
                </a>
                <a
                    href="/courses/"
                    class="inline-flex items-center justify-center gap-2 bg-gray-300 text-gray-900 px-6 py-3 rounded-2xl font-semibold hover:bg-gray-400 transition-colors duration-300"
                >
                    Jelajahi Kelas
                </a>
            </div>
        </div>
    </div>
</div>
{% endblock %}
````

## File: main/templates/base_chat.html
````html
{% load static %}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}Chat - MamiCoach{% endblock %}</title>
    <link rel="icon" type="image/png" href="{% static 'images/logo.png' %}">
    <script src="https://cdn.jsdelivr.net/npm/dompurify@3.0.6/dist/purify.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet">
    <style type="text/tailwindcss">
        @theme {
        --color-primary: #35A753;
        --color-secondary: #FFC27A;
        --font-quicksand: 'Quicksand', sans-serif;
        --font-public-sans: 'Public Sans', sans-serif;
        }
    </style>
    <script src="{% static 'js/toast.js' %}"></script>
</head>
<body class="font-quicksand h-screen flex flex-col overflow-hidden">
    {% csrf_token %}
    {% include 'partials/_navbar.html' %}
    <main class="flex-grow flex flex-col overflow-hidden">
        {% block content %}{% endblock %}
    </main>
    <script>
        // Global CSRF token setup for all AJAX requests
        function getCookie(name) {
            let cookieValue = null;
            if (document.cookie && document.cookie !== '') {
                const cookies = document.cookie.split(';');
                for (let i = 0; i < cookies.length; i++) {
                    const cookie = cookies[i].trim();
                    if (cookie.substring(0, name.length + 1) === (name + '=')) {
                        cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                        break;
                    }
                }
            }
            return cookieValue;
        }
        // Set CSRF token globally for all fetch requests
        const csrftoken = getCookie('csrftoken');
        // Override fetch to automatically include CSRF token
        const originalFetch = window.fetch;
        window.fetch = function(url, options = {}) {
            // Only add CSRF token for same-origin requests
            if (!options.headers) {
                options.headers = {};
            }
            // Add CSRF token for POST requests
            if (options.method && options.method.toUpperCase() === 'POST') {
                options.headers['X-CSRFToken'] = csrftoken;
            }
            // Set content type for JSON requests
            if (!options.headers['Content-Type'] && options.body && typeof options.body === 'string') {
                options.headers['Content-Type'] = 'application/json';
            }
            return originalFetch(url, options);
        };
    </script>
</body>
</html>
````

## File: main/templates/base.html
````html
{% load static %}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}MamiCoach{% endblock %}</title>
    <link rel="icon" type="image/png" href="{% static 'images/logo.png' %}">
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet">
    <style type="text/tailwindcss">
        @theme {
        --color-primary: #35A753;
        --color-secondary: #FFC27A;
        --font-quicksand: 'Quicksand', sans-serif;
        --font-public-sans: 'Public Sans', sans-serif;
        }
    </style>
    <script src="{% static 'js/toast.js' %}"></script>
    {% block meta %}{% endblock %}
</head>
<body class="font-quicksand min-h-screen flex flex-col">
    {% csrf_token %}
    {% include 'partials/_navbar.html' %}
    <main class="flex-grow">
        {% block content %}{% endblock %}
    </main>
    {% include 'partials/_footer.html' %}
</body>
<script>
document.addEventListener('DOMContentLoaded', function() {
    {% if messages %}
        {% for message in messages %}
            // Map Django message tags to our toast types (success, error, info)
            showToast("{{ message|escapejs }}", "{% if 'error' in message.tags %}error{% elif 'warning' in message.tags %}error{% elif 'success' in message.tags %}success{% else %}info{% endif %}");
        {% endfor %}
    {% endif %}
});
</script>
</html>
````

## File: main/admin.py
````python

````

## File: main/apps.py
````python
class MainConfig(AppConfig)
⋮----
default_auto_field = 'django.db.models.BigAutoField'
name = 'main'
````

## File: main/urls.py
````python
app_name = "main"
urlpatterns = [
````

## File: main/views.py
````python
def show_main(request)
⋮----
top_reviews = Review.objects.select_related(
featured_courses = (
categories = Category.objects.all().order_by("name")
top_coaches = CoachProfile.objects.filter(verified=True).order_by("-rating")[:6]
context = {
⋮----
def handler_404(request, exception=None)
def handler_500(request)
````

## File: mami_coach/asgi.py
````python
application = get_asgi_application()
````

## File: mami_coach/settings.py
````python
dj_database_url = None
⋮----
BASE_DIR = Path(__file__).resolve().parent.parent
SECRET_KEY = "django-insecure-n-asrwt9=fz@@+*_ru@8g*v_5hws!zu52!8*a%j#^xeky+pwj4"
PRODUCTION = os.getenv("PRODUCTION", "False").lower() == "true"
SCHEMA = os.getenv("SCHEMA", "public")
DEBUG = not PRODUCTION
ALLOWED_HOSTS = ["localhost", "127.0.0.1", "kevin-cornellius-mamicoach.pbp.cs.ui.ac.id"]
CSRF_TRUSTED_ORIGINS = [
# Application definition
INSTALLED_APPS = [
MIDDLEWARE = [
ROOT_URLCONF = "mami_coach.urls"
TEMPLATES = [
WSGI_APPLICATION = "mami_coach.wsgi.application"
# Database
# https://docs.djangoproject.com/en/5.2/ref/settings/#databases
⋮----
# Production: gunakan PostgreSQL dengan kredensial dari environment variables
# Tambahkan dukungan SSL (Neon membutuhkan SSL). Default sslmode=require.
# Penting: JANGAN kirimkan 'options' search_path di startup packet (Neon pooler tidak mendukung)
db_options: dict[str, str] = {}
# SSL settings (compatible dengan Neon). Dapat dioverride via env.
sslmode = os.getenv("DB_SSLMODE", "require")  # Neon umumnya membutuhkan 'require'
⋮----
# Opsi tambahan bila dibutuhkan (opsional): path sertifikat
⋮----
val = os.getenv(env_key)
⋮----
# Prefer DATABASE_URL when provided (e.g., from Neon dashboard)
database_url = os.getenv("DATABASE_URL")
⋮----
db_cfg = dj_database_url.parse(
# Merge search_path and any explicit SSL overrides into OPTIONS
merged_options = {**db_cfg.get("OPTIONS", {}), **db_options}
# Apply explicit SSL files if provided
⋮----
DATABASES = {"default": db_cfg}
⋮----
DATABASES = {
⋮----
# Development: gunakan SQLite
⋮----
# Password validation
# https://docs.djangoproject.com/en/5.2/ref/settings/#auth-password-validators
AUTH_PASSWORD_VALIDATORS = [
# Internationalization
# https://docs.djangoproject.com/en/5.2/topics/i18n/
LANGUAGE_CODE = "en-us"
TIME_ZONE = "Asia/Jakarta"
USE_I18N = True
USE_TZ = True
# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.2/howto/static-files/
STATIC_URL = "/static/"
⋮----
STATICFILES_DIRS = [
⋮----
BASE_DIR / "static"  # merujuk ke /static root project pada mode development
⋮----
STATIC_ROOT = BASE_DIR / "static"
# Media files (User uploads)
# https://docs.djangoproject.com/en/5.2/howto/manage-files/
# Check if we should use R2 even in development (for testing)
USE_R2 = DEBUG and os.getenv("USE_R2_LOCALLY", "False").lower() == "true" or not DEBUG
⋮----
# Development: use local filesystem (default)
MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "media"
⋮----
# Use Cloudflare R2 (either production or local testing with USE_R2_LOCALLY=True)
STORAGES = {
⋮----
"querystring_auth": False,  # Allow public access to files
⋮----
MEDIA_URL = f"https://{os.getenv('R2_CUSTOM_DOMAIN')}/{os.getenv('R2_BUCKET_NAME')}/media/"
# Default primary key field type
# https://docs.djangoproject.com/en/5.2/ref/settings/#default-auto-field
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"
# Base URL for external callbacks (Midtrans)
BASE_URL = os.getenv('BASE_URL', 'https://kevin-cornellius-mamicoach.pbp.cs.ui.ac.id')
# Set PostgreSQL search_path after each new connection (avoid startup 'options' not supported by Neon pooler)
⋮----
from django.db.backends.signals import connection_created  # type: ignore
from django.dispatch import receiver  # type: ignore
⋮----
@receiver(connection_created)
    def set_postgres_search_path(sender, connection, **kwargs):  # pragma: no cover
⋮----
# Don't crash the app if setting search_path fails; log if needed
````

## File: mami_coach/urls.py
````python
urlpatterns = [
⋮----
handler404 = "main.views.handler_404"
handler500 = "main.views.handler_500"
````

## File: mami_coach/wsgi.py
````python
application = get_wsgi_application()
````

## File: payment/migrations/0001_initial.py
````python
class Migration(migrations.Migration)
⋮----
initial = True
dependencies = [
operations = [
````

## File: payment/templates/payment/callback.html
````html
{% extends 'base.html' %}
{% load static %}
{% block title %}Status Pembayaran - MamiCoach{% endblock %}
{% block extra_head %}
<script src="{% static 'js/toast.js' %}"></script>
<script src="{% static 'js/payment-callback.js' %}"></script>
{% endblock %}
{% block content %}
<div class="container mx-auto px-4 py-8 max-w-2xl">
    <div class="bg-white rounded-lg shadow-lg p-8 text-center">
        {% if page_type == 'unfinish' %}
        <div class="mb-6">
            <div class="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-yellow-100 mb-4">
                <svg class="h-12 w-12 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                </svg>
            </div>
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Pembayaran Belum Selesai</h1>
            <p class="text-gray-600">{{ message }}</p>
        </div>
        <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-6 mb-6 text-left">
            <h2 class="text-lg font-semibold text-gray-900 mb-4">Langkah Selanjutnya?</h2>
            <ul class="space-y-2 text-sm text-gray-700">
                <li>• Booking Anda masih menunggu pembayaran</li>
                <li>• Anda dapat menyelesaikan pembayaran kapan saja dari dashboard</li>
                <li>• Link pembayaran akan aktif selama 24 jam</li>
            </ul>
        </div>
        <div class="flex gap-4 justify-center">
            {% if payment.payment_url %}
            <a href="{{ payment.payment_url }}" class="inline-block bg-emerald-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-emerald-700 transition-colors">
                Selesaikan Pembayaran Sekarang
            </a>
            {% endif %}
            <button onclick="showCancelConfirmation()" class="inline-block bg-red-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-red-700 transition-colors">
                Batalkan Booking
            </button>
            <a href="{% url 'user_profile:dashboard_user' %}" class="inline-block bg-gray-200 text-gray-900 px-6 py-3 rounded-lg font-medium hover:bg-gray-300 transition-colors">
                Ke Dashboard
            </a>
        </div>
        {% elif page_type == 'error' %}
        <div class="mb-6">
            <div class="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-red-100 mb-4">
                <svg class="h-12 w-12 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Kesalahan Pembayaran</h1>
            <p class="text-gray-600">{{ message }}</p>
        </div>
        <div class="bg-red-50 border border-red-200 rounded-lg p-6 mb-6 text-left">
            <h2 class="text-lg font-semibold text-gray-900 mb-4">Solusi</h2>
            <ul class="space-y-2 text-sm text-gray-700">
                <li>• Periksa koneksi internet Anda</li>
                <li>• Verifikasi detail pembayaran Anda dengan benar</li>
                <li>• Hubungi bank Anda jika masalah berlanjut</li>
                <li>• Coba metode pembayaran yang berbeda</li>
            </ul>
        </div>
        <div class="flex gap-4 justify-center">
            <a href="{% url 'payment:method_selection' booking.id %}" class="inline-block bg-emerald-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-emerald-700 transition-colors">
                Coba Lagi
            </a>
            <a href="{% url 'user_profile:dashboard_user' %}" class="inline-block bg-gray-200 text-gray-900 px-6 py-3 rounded-lg font-medium hover:bg-gray-300 transition-colors">
                Ke Dashboard
            </a>
        </div>
        {% elif is_success %}
        <div class="mb-6">
            <div class="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-emerald-100 mb-4">
                <svg class="h-12 w-12 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                </svg>
            </div>
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Pembayaran Berhasil!</h1>
            <p class="text-gray-600">Booking Anda telah dikonfirmasi dan pembayaran diterima.</p>
        </div>
        <div class="bg-emerald-50 border border-emerald-200 rounded-lg p-6 mb-6 text-left">
            <h2 class="text-lg font-semibold text-gray-900 mb-4">Informasi Booking</h2>
            <div class="space-y-2 text-sm">
                <div class="flex justify-between">
                    <span class="text-gray-600">ID Booking:</span>
                    <span class="font-medium text-gray-900">#{{ booking.id }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Kursus:</span>
                    <span class="font-medium text-gray-900">{{ booking.course.title }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Coach:</span>
                    <span class="font-medium text-gray-900">{{ booking.coach.user.get_full_name|default:booking.coach.user.username }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Tanggal & Waktu:</span>
                    <span class="font-medium text-gray-900">{{ booking.start_datetime|date:"d M Y, H:i" }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Jumlah Dibayar:</span>
                    <span class="font-medium text-emerald-600">Rp {{ payment.amount|floatformat:0 }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Metode Pembayaran:</span>
                    <span class="font-medium text-gray-900">{{ payment.get_method_display }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">ID Pesanan:</span>
                    <span class="font-medium text-gray-900">{{ payment.order_id }}</span>
                </div>
            </div>
        </div>
        <div class="bg-emerald-50 border border-emerald-200 rounded-lg p-4 mb-6">
            <p class="text-sm text-emerald-900">
                <strong>Langkah Selanjutnya:</strong> Silakan tunggu konfirmasi coach terhadap booking Anda. Anda akan menerima notifikasi setelah dikonfirmasi.
            </p>
        </div>
        {% elif is_pending %}
        <div class="mb-6">
            <div class="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-yellow-100 mb-4">
                <svg class="h-12 w-12 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Pembayaran Tertunda</h1>
            <p class="text-gray-600">Pembayaran Anda sedang diproses. Silakan selesaikan pembayaran.</p>
        </div>
        <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-6 mb-6 text-left">
            <h2 class="text-lg font-semibold text-gray-900 mb-4">Detail Pembayaran</h2>
            <div class="space-y-2 text-sm">
                <div class="flex justify-between">
                    <span class="text-gray-600">ID Pesanan:</span>
                    <span class="font-medium text-gray-900">{{ payment.order_id }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Jumlah:</span>
                    <span class="font-medium text-gray-900">Rp {{ payment.amount|floatformat:0 }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Metode Pembayaran:</span>
                    <span class="font-medium text-gray-900">{{ payment.get_method_display }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Status:</span>
                    <span class="font-medium text-yellow-600">Tertunda</span>
                </div>
            </div>
        </div>
        {% if payment.payment_url %}
        <a href="{{ payment.payment_url }}" class="inline-block bg-emerald-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-emerald-700 transition-colors mb-4">
            Selesaikan Pembayaran
        </a>
        {% endif %}
        <button onclick="showCancelConfirmation()" class="inline-block bg-red-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-red-700 transition-colors">
            Batalkan Booking
        </button>
        <button onclick="checkPaymentStatus('{% url 'payment:status' payment.id %}')" class="inline-block bg-gray-200 text-gray-900 px-6 py-3 rounded-lg font-medium hover:bg-gray-300 transition-colors mr-2">
            Refresh Status
        </button>
        {% else %}
        <div class="mb-6">
            <div class="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-red-100 mb-4">
                <svg class="h-12 w-12 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </div>
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Pembayaran Gagal</h1>
            <p class="text-gray-600">Sayangnya, pembayaran Anda tidak dapat diproses.</p>
        </div>
        <div class="bg-red-50 border border-red-200 rounded-lg p-6 mb-6 text-left">
            <h2 class="text-lg font-semibold text-gray-900 mb-4">Detail Pembayaran</h2>
            <div class="space-y-2 text-sm">
                <div class="flex justify-between">
                    <span class="text-gray-600">ID Pesanan:</span>
                    <span class="font-medium text-gray-900">{{ payment.order_id }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Status:</span>
                    <span class="font-medium text-red-600">{{ payment.get_status_display }}</span>
                </div>
            </div>
        </div>
        <a href="{% url 'payment:method_selection' booking.id %}" class="inline-block bg-emerald-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-emerald-700 transition-colors">
            Coba Lagi
        </a>
        {% endif %}
        <div class="mt-6">
            <a href="{% url 'user_profile:dashboard_user' %}" class="text-emerald-600 hover:text-emerald-700 font-medium">
                Lihat Dashboard Saya
            </a>
        </div>
    </div>
</div>
<div id="cancel-confirmation-modal" class="hidden fixed inset-0 bg-black/50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-lg p-6 max-w-sm w-full mx-4">
        <h3 class="text-lg font-semibold text-gray-900 mb-2">Batalkan Booking?</h3>
        <p class="text-gray-600 mb-6">Apakah Anda yakin ingin membatalkan booking ini? Tindakan ini tidak dapat dibatalkan.</p>
        <div class="flex gap-3 justify-end">
            <button onclick="closeCancelModal()"
                    class="bg-gray-300 hover:bg-gray-400 text-gray-900 px-6 py-2 rounded-lg text-sm font-medium transition-colors">
                Tidak
            </button>
            <button onclick="confirmCancelBooking({{ booking.id }}, '{% url 'user_profile:dashboard_user' %}')"
                    class="bg-red-600 hover:bg-red-700 text-white px-6 py-2 rounded-lg text-sm font-medium transition-colors">
                Ya, Batalkan
            </button>
        </div>
    </div>
</div>
<script>
// Auto-refresh for pending payments
{% if is_pending %}
setInterval(function() {
    checkPaymentStatus('{% url 'payment:status' payment.id %}');
}, 5000); // Check every 5 seconds
{% endif %}
</script>
{% endblock %}
````

## File: payment/templates/payment/method_selection.html
````html
{% extends 'base.html' %}
{% load static %}
{% block title %}Pilih Metode Pembayaran - MamiCoach{% endblock %}
{% block extra_css %}
    <link rel="stylesheet" href="{% static 'css/payment.css' %}">
{% endblock %}
{% block content %}
<div class="container mx-auto px-4 py-8 max-w-4xl">
    <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
        <h1 class="text-3xl font-bold text-gray-900 mb-6">Selesaikan Pemesanan Anda</h1>
        <div class="bg-gradient-to-br from-green-50 to-blue-50 rounded-lg p-6 mb-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Detail Pemesanan</h2>
            <div class="space-y-3">
                <div class="flex justify-between">
                    <span class="text-gray-600">Kursus:</span>
                    <span class="font-medium text-gray-900">{{ course.title }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Coach:</span>
                    <span class="font-medium text-gray-900">{{ coach.user.get_full_name|default:coach.user.username }}</span>
                </div>
                <div class="flex justify-between">
                    <span class="text-gray-600">Tanggal & Waktu:</span>
                    <span class="font-medium text-gray-900">
                        {{ booking.start_datetime|date:"d M Y, H:i" }} - {{ booking.end_datetime|date:"H:i" }}
                    </span>
                </div>
                <hr class="my-3">
                <div class="flex justify-between text-lg">
                    <span class="font-semibold text-gray-900">Total Pembayaran:</span>
                    <span class="font-bold text-emerald-600">Rp {{ amount|floatformat:0 }}</span>
                </div>
            </div>
        </div>
        <div class="mb-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Pilih Metode Pembayaran</h2>
            <form id="payment-form" method="post" action="{% url 'payment:process' booking.id %}">
                {% csrf_token %}
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {% for method_value, method_label in payment_methods %}
                    <label class="payment-method-card relative flex items-center p-4 border-2 border-gray-200 rounded-lg cursor-pointer hover:border-emerald-500 hover:bg-green-50 transition-all">
                        <input type="radio" name="payment_method" value="{{ method_value }}" class="mr-3 h-4 w-4 text-emerald-600" required>
                        <div class="flex-1">
                            <span class="font-medium text-gray-900">{{ method_label }}</span>
                        </div>
                        <div class="payment-icon ml-2">
                            {% if 'VA' in method_label or 'Virtual Account' in method_label %}
                                <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                                </svg>
                            {% elif 'Credit Card' in method_label %}
                                <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                                </svg>
                            {% elif 'Indomaret' in method_label or 'Alfamart' in method_label %}
                                <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
                                </svg>
                            {% else %}
                                <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                            {% endif %}
                        </div>
                    </label>
                    {% endfor %}
                </div>
                <div class="mt-8 flex gap-4">
                    <a href="{% url 'user_profile:dashboard_user' %}" class="flex-1 bg-gray-200 text-gray-900 px-6 py-3 rounded-lg font-medium hover:bg-gray-300 transition-colors text-center">
                        Batal
                    </a>
                    <button type="submit" id="pay-button" class="flex-1 bg-gradient-to-r from-emerald-600 to-green-600 text-white px-6 py-3 rounded-lg font-medium hover:shadow-lg hover:from-emerald-700 hover:to-green-700 transition-all disabled:opacity-50 disabled:cursor-not-allowed">
                        Lanjut ke Pembayaran
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="{% static 'js/payment-method.js' %}"></script>
{% endblock %}
````

## File: payment/admin.py
````python
@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin)
⋮----
list_display = [
list_filter = ['status', 'method', 'created_at']
search_fields = ['order_id', 'transaction_id', 'user__username', 'booking__id']
readonly_fields = [
fieldsets = (
def get_booking_display(self, obj)
⋮----
def get_user_display(self, obj)
⋮----
def get_amount_display(self, obj)
⋮----
def get_method_display(self, obj)
⋮----
def has_add_permission(self, request)
````

## File: payment/apps.py
````python
class PaymentConfig(AppConfig)
⋮----
default_auto_field = "django.db.models.BigAutoField"
name = "payment"
````

## File: payment/midtrans_service.py
````python
class MidtransService
⋮----
def __init__(self)
def _get_auth_header(self) -> str
⋮----
auth_string = f"{self.server_key}:"
auth_bytes = auth_string.encode('utf-8')
auth_b64 = base64.b64encode(auth_bytes).decode('utf-8')
⋮----
def _map_payment_method_to_midtrans(self, method: str) -> Dict
⋮----
mapping = {
⋮----
url = f"{self.base_url}/transactions"
headers = {
base_url = getattr(settings, 'BASE_URL', 'https://kevin-cornellius-mamicoach.pbp.cs.ui.ac.id')
payload = {
⋮----
enabled_payments = self._map_payment_method_to_midtrans(payment_method)
⋮----
response = requests.post(url, headers=headers, json=payload, timeout=30)
⋮----
data = response.json()
⋮----
def get_transaction_status(self, order_id: str) -> Dict
⋮----
url = f"{self.api_url}/{order_id}/status"
⋮----
response = requests.get(url, headers=headers, timeout=30)
⋮----
def verify_signature(self, order_id: str, status_code: str, gross_amount: str, signature_key: str) -> bool
⋮----
string_to_hash = f"{order_id}{status_code}{gross_amount}{self.server_key}"
hash_result = hashlib.sha512(string_to_hash.encode('utf-8')).hexdigest()
````

## File: payment/models.py
````python
class Payment(models.Model)
⋮----
PAYMENT_METHOD_CHOICES = [
STATUS_CHOICES = [
booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name='payments')
user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='payments')
amount = models.IntegerField(help_text="Amount in IDR")
method = models.CharField(max_length=50, choices=PAYMENT_METHOD_CHOICES, null=True, blank=True)
order_id = models.CharField(max_length=255, unique=True)
transaction_id = models.CharField(max_length=255, null=True, blank=True)
transaction_ref = models.CharField(max_length=255, null=True, blank=True)
status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
payment_url = models.TextField(null=True, blank=True)
created_at = models.DateTimeField(auto_now_add=True)
updated_at = models.DateTimeField(auto_now=True)
paid_at = models.DateTimeField(null=True, blank=True)
midtrans_response = models.JSONField(null=True, blank=True)
class Meta
⋮----
ordering = ['-created_at']
indexes = [
def __str__(self)
⋮----
@property
    def is_successful(self)
⋮----
@property
    def is_pending(self)
⋮----
@property
    def is_failed(self)
````

## File: payment/urls.py
````python
app_name = 'payment'
urlpatterns = [
````

## File: payment/views.py
````python
@login_required
@require_http_methods(["GET"])
def payment_method_selection(request, booking_id)
⋮----
booking = get_object_or_404(Booking, id=booking_id, user=request.user)
⋮----
course = booking.course
coach = booking.coach
amount = getattr(course, 'price', 0)
context = {
⋮----
@login_required
@require_POST
def process_payment(request, booking_id)
⋮----
payment_method = request.POST.get('payment_method')
⋮----
valid_methods = [choice[0] for choice in Payment.PAYMENT_METHOD_CHOICES]
⋮----
order_id = f"MAMI-{booking.id}-{uuid.uuid4().hex[:8].upper()}"
payment = Payment.objects.create(
midtrans = MidtransService()
customer_details = {
item_details = [
result = midtrans.create_transaction(
⋮----
@csrf_exempt
@require_POST
def midtrans_webhook(request)
⋮----
data = json.loads(request.body)
order_id = data.get('order_id')
transaction_status = data.get('transaction_status')
fraud_status = data.get('fraud_status')
status_code = data.get('status_code')
gross_amount = data.get('gross_amount')
signature_key = data.get('signature_key')
transaction_id = data.get('transaction_id')
⋮----
is_valid = midtrans.verify_signature(
⋮----
response = HttpResponse(
⋮----
payment = Payment.objects.get(order_id=order_id)
⋮----
booking = payment.booking
⋮----
def mark_booking_as_paid(booking_id: int, payment_id: int, payment_method: str)
⋮----
booking = Booking.objects.get(id=booking_id)
⋮----
def payment_callback(request)
⋮----
order_id = request.GET.get('order_id')
transaction_status = request.GET.get('transaction_status')
status_code = request.GET.get('status_code')
⋮----
status_result = midtrans.get_transaction_status(payment.order_id)
⋮----
status_data = status_result.get('data', {})
api_transaction_status = status_data.get('transaction_status')
⋮----
def payment_unfinish(request)
def payment_error(request)
⋮----
@login_required
def payment_status(request, payment_id)
⋮----
payment = get_object_or_404(Payment, id=payment_id, user=request.user)
⋮----
result = midtrans.get_transaction_status(payment.order_id)
⋮----
status_data = result.get('data', {})
transaction_status = status_data.get('transaction_status')
````

## File: reviews/migrations/0001_initial.py
````python
class Migration(migrations.Migration)
⋮----
initial = True
dependencies = [
operations = [
````

## File: reviews/templates/pages/create_review.html
````html
{% extends 'base.html' %}
{% block title %}Write a Review - MamiCoach{% endblock %}
{% block content %}
{% include 'partials/_review_form.html' with is_edit=False form_action="" callback_url=callback_url %}
{% endblock %}
````

## File: reviews/templates/pages/edit_review.html
````html
{% extends 'base.html' %}
{% block title %}Edit Review - MamiCoach{% endblock %}
{% block content %}
{% url 'reviews:delete_review' review.id as delete_action %}
{% include 'partials/_review_form.html' with is_edit=True form_action="" delete_action=delete_action callback_url=callback_url %}
{% endblock %}
````

## File: reviews/templates/pages/sample_review.html
````html
{% extends 'base.html' %}
{% block title %}Review Kursus - MamiCoach{% endblock %}
{% block content %}
<section class="min-h-screen bg-gradient-to-br from-neutral-50 to-neutral-100 py-8 sm:py-12">
	<div class="mx-auto max-w-4xl px-4 sm:px-6 lg:px-8">
		<div class="mb-8 text-center">
			<h1 class="text-3xl font-bold text-neutral-900 sm:text-4xl">
				Review Kursus
			</h1>
			<p class="mt-2 text-lg text-neutral-600">
				Lihat apa yang dikatakan siswa kami tentang pengalaman belajar mereka
			</p>
		</div>
		<div class="mb-8 text-center">
			<div class="inline-flex rounded-lg border border-neutral-300 bg-white p-1">
				<button
					id="original-style-btn"
					class="rounded-md px-4 py-2 text-sm font-medium transition-colors bg-primary text-white"
				>
					Gaya Asli
				</button>
				<button
					id="styled-style-btn"
					class="rounded-md px-4 py-2 text-sm font-medium transition-colors text-neutral-700 hover:text-neutral-900"
				>
					Kartu Bergaya
				</button>
			</div>
		</div>
		<div id="original-reviews" class="space-y-6">
			{% for review in reviews %}
				{% include 'partials/_review_card.html' with review=review %}
			{% empty %}
				<div class="rounded-2xl bg-white p-12 text-center shadow-sm ring-1 ring-black/5">
					<svg class="mx-auto h-12 w-12 text-neutral-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-1l-4 4z"></path>
					</svg>
					<h3 class="mt-4 text-lg font-semibold text-neutral-900">Belum ada review</h3>
					<p class="mt-2 text-neutral-600">Jadilah yang pertama berbagi pengalaman Anda!</p>
				</div>
			{% endfor %}
		</div>
		<div id="styled-reviews" class="space-y-6 hidden">
			{% for review in reviews %}
				{% include 'partials/_review_card_styled.html' with review=review %}
			{% empty %}
				<div class="rounded-2xl bg-white p-12 text-center shadow-sm ring-1 ring-black/5">
					<svg class="mx-auto h-12 w-12 text-neutral-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-1l-4 4z"></path>
					</svg>
					<h3 class="mt-4 text-lg font-semibold text-neutral-900">Belum ada review</h3>
					<p class="mt-2 text-neutral-600">Jadilah yang pertama berbagi pengalaman Anda!</p>
				</div>
			{% endfor %}
		</div>
		{% if reviews|length > 5 %}
		<div class="mt-12 flex justify-center">
			<nav class="flex items-center gap-2">
				<button class="rounded-lg border border-neutral-300 bg-white px-4 py-2 text-sm font-medium text-neutral-700 hover:bg-neutral-50">
					Sebelumnya
				</button>
				<button class="rounded-lg bg-primary px-4 py-2 text-sm font-medium text-white">
					1
				</button>
				<button class="rounded-lg border border-neutral-300 bg-white px-4 py-2 text-sm font-medium text-neutral-700 hover:bg-neutral-50">
					2
				</button>
				<button class="rounded-lg border border-neutral-300 bg-white px-4 py-2 text-sm font-medium text-neutral-700 hover:bg-neutral-50">
					Berikutnya
				</button>
			</nav>
		</div>
		{% endif %}
	</div>
</section>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const originalBtn = document.getElementById('original-style-btn');
    const styledBtn = document.getElementById('styled-style-btn');
    const originalReviews = document.getElementById('original-reviews');
    const styledReviews = document.getElementById('styled-reviews');
    originalBtn.addEventListener('click', function() {
        // Show original reviews
        originalReviews.classList.remove('hidden');
        styledReviews.classList.add('hidden');
        // Update button styles
        originalBtn.classList.add('bg-primary', 'text-white');
        originalBtn.classList.remove('text-neutral-700', 'hover:text-neutral-900');
        styledBtn.classList.remove('bg-primary', 'text-white');
        styledBtn.classList.add('text-neutral-700', 'hover:text-neutral-900');
    });
    styledBtn.addEventListener('click', function() {
        // Show styled reviews
        styledReviews.classList.remove('hidden');
        originalReviews.classList.add('hidden');
        // Update button styles
        styledBtn.classList.add('bg-primary', 'text-white');
        styledBtn.classList.remove('text-neutral-700', 'hover:text-neutral-900');
        originalBtn.classList.remove('bg-primary', 'text-white');
        originalBtn.classList.add('text-neutral-700', 'hover:text-neutral-900');
    });
});
</script>
{% endblock %}
````

## File: reviews/templates/partials/_review_card_styled.html
````html
<div class="relative h-60 w-full flex flex-col">
    <div class="bg-primary rounded-3xl shadow-lg flex-1 flex flex-col">
        <div class="bg-white rounded-2xl shadow-sm border border-neutral-100 relative flex-1 flex flex-col">
            <div class="absolute top-6 right-6 flex-shrink-0">
                <svg class="h-8 w-8 text-primary" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h4v10h-10z"/>
                </svg>
            </div>
            <div class="p-6 pb-4 flex-1 overflow-y-auto flex flex-col">
                <div class="flex items-start gap-3 mb-4 flex-shrink-0">
                    {% if review.is_anonymous %}
                        <div class="h-12 w-12 overflow-hidden rounded-full flex-shrink-0 bg-neutral-300 flex items-center justify-center">
                            <svg class="h-6 w-6 text-neutral-500" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z" />
                            </svg>
                        </div>
                    {% else %}
                        <div class="h-12 w-12 overflow-hidden rounded-full flex-shrink-0">
                            <img src="{{ review.user.userprofile.image_url }}"
                                 alt="{{ review.user.username }} avatar"
                                 class="h-full w-full object-cover" />
                        </div>
                    {% endif %}
                    <div class="flex-1 min-w-0">
                        <h3 class="text-lg font-semibold text-neutral-900">
                            {% if review.is_anonymous %}
                            Anonymous User
                            {% else %}
                            {{ review.user.first_name|default:review.user.username }}
                            {% endif %}
                        </h3>
                        <p class="text-xs text-neutral-600 mt-0.5 truncate">{{ review.course.title }}</p>
                    </div>
                </div>
                <div class="text-neutral-700 leading-relaxed text-sm line-clamp-4 flex-1">
                    {{ review.content|linebreaksbr }}
                </div>
            </div>
        </div>
        <div class="px-4 py-2 flex items-center justify-between gap-2 min-w-0 flex-shrink-0">
            <div class="flex items-center gap-1 min-w-0">
                {% for star in "12345" %}
                    {% if forloop.counter <= review.rating %}
                        <svg class="h-4 w-4 text-yellow-400 flex-shrink-0" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 17.27 18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" />
                        </svg>
                    {% else %}
                        <svg class="h-4 w-4 text-white/30 flex-shrink-0" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 17.27 18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" />
                        </svg>
                    {% endif %}
                {% endfor %}
            </div>
            <a href="{% url 'courses_and_coach:course_details' review.course.id %}" class="text-white font-semibold text-xs truncate hover:text-gray-100 transition-colors flex items-center gap-1">
                <span class="truncate">{{ review.course.title|truncatewords:2 }}</span>
                <svg class="h-4 w-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5l7 7-7 7M12 5l7 7-7 7"/>
                </svg>
            </a>
        </div>
    </div>
</div>
````

## File: reviews/templates/partials/_review_card.html
````html
<div class="bg-white p-4 sm:p-6 rounded-2xl shadow-sm border border-neutral-100">
	<div class="flex flex-col sm:flex-row items-start gap-3 sm:gap-4 mb-4">
		<div class="flex items-start gap-3 sm:gap-4 flex-1 min-w-0">
			{% if review.is_anonymous %}
				<div class="h-12 sm:h-16 w-12 sm:w-16 overflow-hidden rounded-full flex-shrink-0 bg-neutral-300 flex items-center justify-center">
					<svg class="h-6 sm:h-8 w-6 sm:w-8 text-neutral-500" fill="currentColor" viewBox="0 0 24 24">
						<path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z" />
					</svg>
				</div>
			{% else %}
				<div class="h-12 sm:h-16 w-12 sm:w-16 overflow-hidden rounded-full flex-shrink-0">
					<img src="{{ review.user.userprofile.image_url }}" class="h-full w-full object-cover" />
				</div>
			{% endif %}
			<div class="flex-1 min-w-0">
				<h3 class="text-base sm:text-xl font-semibold text-neutral-900 truncate">
					{% if review.is_anonymous %}
						Anonymous User
					{% else %}
						{{ review.user.first_name|default:review.user.username }}
					{% endif %}
				</h3>
				<p class="text-xs sm:text-sm text-neutral-600 mt-1 truncate">{{ review.course.title }}</p>
			</div>
		</div>
		<div class="flex items-center gap-0.5 sm:gap-1 flex-shrink-0">
			{% for star in "12345" %}
				{% if forloop.counter <= review.rating %}
					<svg class="h-5 sm:h-7 w-5 sm:w-7 text-primary" viewBox="0 0 24 24" fill="currentColor">
						<path d="M12 17.27 18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" />
					</svg>
				{% else %}
					<svg class="h-5 sm:h-7 w-5 sm:w-7 text-neutral-300" viewBox="0 0 24 24" fill="currentColor">
						<path d="M12 17.27 18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" />
					</svg>
				{% endif %}
			{% endfor %}
		</div>
	</div>
	<div class="text-neutral-700 leading-relaxed text-sm sm:text-base space-y-3 sm:space-y-4">
		{{ review.content|linebreaksbr }}
	</div>
	<div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 mt-4">
		<div class="text-xs sm:text-sm text-neutral-500">
			{{ review.created_at|date:"M d, Y" }}
		</div>
		{% if user.is_authenticated and user == review.user %}
		<a href="{% url 'reviews:edit_review' review.id %}?next={{ request.path }}" class="flex items-center gap-1 text-xs sm:text-sm px-2 sm:px-3 py-1 bg-primary/10 text-primary rounded-lg hover:bg-primary/20 transition-colors whitespace-nowrap">
			<svg class="h-3 w-3 sm:h-4 sm:w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
			</svg>
			Edit
		</a>
		{% endif %}
	</div>
</div>
````

## File: reviews/templates/partials/_review_form.html
````html
<section class="min-h-screen bg-gradient-to-br from-neutral-50 to-neutral-100 py-6 sm:py-12">
	<div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
		<div class="mb-8 text-center lg:text-left">
			<p class="text-sm font-medium text-neutral-500 sm:text-base">Review Kursus Pemesanan#{{ booking.id }}</p>
			<h1 class="mt-2 text-2xl font-bold text-neutral-900 sm:text-3xl lg:text-4xl">
				{% if is_edit %}
					Edit review Anda untuk <span class="text-primary">{{ review.coach.user.first_name|default:review.coach.user.username }}</span>
				{% else %}
					Review pengalaman Anda dengan <span class="text-primary">{{ booking.coach.user.first_name|default:booking.coach.user.username }}</span>
				{% endif %}
			</h1>
			<p class="mt-2 text-lg text-neutral-600 font-semibold">
				{% if is_edit %}
					{{ review.course.title }}
				{% else %}
					{{ booking.course.title }}
				{% endif %}
			</p>
		</div>
		<div class="grid grid-cols-1 gap-6 lg:grid-cols-12 lg:gap-8">
			<div class="lg:col-span-5">
				<div class="sticky top-24 rounded-2xl bg-white p-6 shadow-lg ring-1 ring-black/5 sm:p-8">
					<div class="mb-6 space-y-3">
						<div class="flex items-center gap-3 text-sm text-neutral-600 sm:text-base">
							<svg class="h-5 w-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3a1 1 0 011-1h6a1 1 0 011 1v4m-6 0h6m-6 0V3m6 4v10a1 1 0 01-1 1H9a1 1 0 01-1-1V7"></path>
							</svg>
							<span><span class="font-semibold text-neutral-800">Booked:</span>
								{% if is_edit %}
									{{ review.booking.start_datetime|date:"H:i \a\t d M Y" }}
								{% else %}
									{{ booking.start_datetime|date:"H:i \a\t d M Y" }}
								{% endif %}
							</span>
						</div>
						<div class="flex items-center gap-3 text-sm text-neutral-600 sm:text-base">
							<svg class="h-5 w-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
								<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
							</svg>
							<span><span class="font-semibold text-neutral-800">Duration:</span>
								{% if is_edit %}
									{% with booking=review.booking %}
										{% if booking.start_datetime and booking.end_datetime %}
											{{ booking.end_datetime|timeuntil:booking.start_datetime }}
										{% else %}
											Unknown duration
										{% endif %}
									{% endwith %}
								{% else %}
									{% if booking.start_datetime and booking.end_datetime %}
										{{ booking.end_datetime|timeuntil:booking.start_datetime }}
									{% else %}
										Unknown duration
									{% endif %}
								{% endif %}
							</span>
						</div>
					</div>
					<div class="overflow-hidden rounded-xl">
						<img
							src="{% if is_edit %}{{ review.course.thumbnail_url|default:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcTY50AnR35-aKaONIPoeLNh_KrvAq9bwD7A&s' }}{% else %}{{ booking.course.thumbnail_url|default:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcTY50AnR35-aKaONIPoeLNh_KrvAq9bwD7A&s' }}{% endif %}"
							alt="{% if is_edit %}{{ review.course.title }}{% else %}{{ booking.course.title }}{% endif %}"
							class="h-48 w-full object-cover transition-transform hover:scale-105 sm:h-64 lg:h-72"
						/>
					</div>
				</div>
			</div>
			<div class="lg:col-span-7">
				<form method="post" id="review-form" class="rounded-2xl bg-white p-6 shadow-lg ring-1 ring-black/5 sm:p-8">
					{% csrf_token %}
					{% if form.non_field_errors %}
						<div class="mb-6 rounded-lg bg-red-50 p-4 border border-red-200">
							{% for error in form.non_field_errors %}
								<p class="text-sm text-red-600">{{ error }}</p>
							{% endfor %}
						</div>
					{% endif %}
					<div id="form-error-alert" class="mb-6 rounded-lg bg-red-50 p-4 border border-red-200 hidden">
						<p class="text-sm font-semibold text-red-700 mb-2">Please fix the following errors:</p>
						<ul id="error-list" class="text-sm text-red-600 space-y-1"></ul>
					</div>
					<div class="mb-8 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
						<div class="flex items-center gap-4">
							<div class="h-12 w-12 overflow-hidden rounded-full ring-2 ring-primary/20 sm:h-16 sm:w-16">
								{% if is_edit %}
									<img src="{{ review.user.userprofile.image_url }}" alt="Reviewer avatar" class="h-full w-full object-cover" />
								{% else %}
									<img src="{{ request.user.userprofile.image_url }}" alt="Reviewer avatar" class="h-full w-full object-cover" />
								{% endif %}
							</div>
							<div>
								<p class="text-lg font-semibold text-neutral-900 sm:text-xl">
									{% if is_edit %}
										{{ review.user.first_name|default:review.user.username }}
									{% else %}
										{{ request.user.first_name|default:request.user.username }}
									{% endif %}
								</p>
								<p class="text-sm text-neutral-500 sm:text-base">
									{% if is_edit %}
										{{ review.user.profile.role|default:"User" }}
									{% else %}
										{{ request.user.profile.role|default:"User" }}
									{% endif %}
								</p>
							</div>
						</div>
						<div class="flex flex-col gap-2">
							<div class="flex items-center gap-2" role="group" aria-label="Rating">
								{{ form.rating }}
								<div class="flex gap-1" id="star-group">
									{% for star in "12345" %}
									<button
										type="button"
										data-role="rating-star"
										data-value="{{ forloop.counter }}"
										class="flex h-8 w-8 items-center justify-center text-neutral-300 transition hover:scale-110 sm:h-10 sm:w-10 rounded-full"
										aria-label="Rate {{ forloop.counter }} star{% if not forloop.last %}s{% endif %}"
									>
										<svg viewBox="0 0 24 24" fill="currentColor" class="h-6 w-6 sm:h-8 sm:w-8">
											<path d="M12 17.27 18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" />
										</svg>
									</button>
									{% endfor %}
								</div>
							</div>
							{% if form.rating.errors %}
								<div class="text-sm text-red-600 mt-1">
									{% for error in form.rating.errors %}
										{{ error }}
									{% endfor %}
								</div>
							{% endif %}
						</div>
					</div>
					<div class="mb-6">
						<label for="{{ form.content.id_for_label }}" class="mb-3 block text-base font-semibold text-neutral-700 sm:text-lg">
							{{ form.content.label }}
						</label>
						{{ form.content }}
						{% if form.content.errors %}
							<p class="mt-2 text-sm text-red-600">{{ form.content.errors.0 }}</p>
						{% endif %}
					</div>
					<div class="mb-8">
						<label class="inline-flex cursor-pointer items-center gap-4 text-neutral-600">
							<div class="relative flex h-6 w-6 items-center justify-center">
								{{ form.is_anonymous }}
								<div class="pointer-events-none absolute inset-0 flex h-6 w-6 items-center justify-center rounded-md bg-[#E6E6E6]">
									<svg id="checkbox-checkmark" viewBox="0 0 20 20" fill="none" class="h-6 w-6 text-[#39A35E] {% if form.is_anonymous.value %}opacity-100{% else %}opacity-0{% endif %} transition-opacity duration-150">
										<path d="M16.707 5.293a1 1 0 0 0-1.414 0L8.5 12.086 6.207 9.793a1 1 0 0 0-1.414 1.414l3 3a1 1 0 0 0 1.414 0l7-7a1 1 0 0 0 0-1.414Z" fill="currentColor" />
									</svg>
								</div>
							</div>
							<span class="text-sm sm:text-base font-semibold">Post anonymously</span>
						</label>
						{% if form.is_anonymous.errors %}
							<p class="mt-2 text-sm text-red-600">{{ form.is_anonymous.errors.0 }}</p>
						{% endif %}
					</div>
					<div class="flex flex-col gap-3 sm:flex-row">
						{% if is_edit %}
							<button
								type="submit"
								id="submit-btn"
								class="flex-1 rounded-xl bg-primary px-6 py-4 text-base font-semibold text-white shadow-md transition hover:bg-primary/90 hover:shadow-lg focus:outline-none focus:ring-2 focus:ring-primary/40 focus:ring-offset-2 active:scale-[0.98] sm:text-lg disabled:opacity-50 disabled:cursor-not-allowed"
							>
								Perbarui Review
							</button>
							<button
								type="button"
								onclick="openDeleteModal()"
								class="flex-1 rounded-xl bg-red-500 px-6 py-4 text-base font-semibold text-white shadow-md transition hover:bg-red-600 hover:shadow-lg focus:outline-none focus:ring-2 focus:ring-red-400 focus:ring-offset-2 active:scale-[0.98] sm:text-lg"
							>
								Hapus Review
							</button>
						{% else %}
							<button
								type="submit"
								id="submit-btn"
								class="w-full rounded-xl bg-primary px-6 py-4 text-base font-semibold text-white shadow-md transition hover:bg-primary/90 hover:shadow-lg focus:outline-none focus:ring-2 focus:ring-primary/40 focus:ring-offset-2 active:scale-[0.98] sm:text-lg disabled:opacity-50 disabled:cursor-not-allowed"
							>
								Kirim Review
							</button>
						{% endif %}
					</div>
				</form>
				{% if is_edit %}
				<form id="delete-form" action="{% if callback_url %}{{ delete_action }}?next={{ callback_url }}{% else %}{{ delete_action }}{% endif %}" method="post" class="hidden">
					{% csrf_token %}
				</form>
				{% endif %}
			</div>
		</div>
	</div>
</section>
{% if is_edit %}
<div id="delete-modal" class="fixed inset-0 z-50 hidden items-center justify-center bg-black/50 backdrop-blur-sm">
	<div class="mx-4 w-full max-w-md rounded-2xl bg-white p-6 shadow-2xl">
		<div class="mb-4 text-center">
			<div class="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-red-100">
				<svg class="h-8 w-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
				</svg>
			</div>
			<h3 class="text-xl font-semibold text-neutral-900">Hapus Review</h3>
			<p class="mt-2 text-sm text-neutral-600">
				Apakah Anda yakin ingin menghapus review ini? Tindakan ini tidak dapat dibatalkan dan akan menghapus review Anda secara permanen dari sistem.
			</p>
		</div>
		<div class="flex gap-3">
			<button
				type="button"
				onclick="closeDeleteModal()"
				class="flex-1 rounded-xl border border-neutral-300 bg-white px-4 py-3 text-sm font-semibold text-neutral-700 shadow-sm transition hover:bg-neutral-50 focus:outline-none focus:ring-2 focus:ring-neutral-500 focus:ring-offset-2"
			>
				Batal
			</button>
			<button
				type="button"
				onclick="confirmDelete()"
				class="flex-1 rounded-xl bg-red-600 px-4 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2"
			>
				Hapus Review
			</button>
		</div>
	</div>
</div>
{% endif %}
<script>
document.addEventListener('DOMContentLoaded', function () {
	const stars = document.querySelectorAll('[data-role="rating-star"]');
	const ratingInput = document.getElementById('rating-value');
	const form = document.getElementById('review-form');
	const submitBtn = document.getElementById('submit-btn');
	const contentInput = document.getElementById('comment');
	const errorAlert = document.getElementById('form-error-alert');
	const errorList = document.getElementById('error-list');
	function syncStars(value) {
		stars.forEach(function (star) {
			const starValue = parseInt(star.dataset.value, 10);
			if (starValue <= value) {
				star.classList.add('text-primary');
				star.classList.remove('text-neutral-300');
			} else {
				star.classList.add('text-neutral-300');
				star.classList.remove('text-primary');
			}
		});
	}
	function validateForm() {
		const errors = [];
		// Check rating
		const rating = parseInt(ratingInput.value, 10);
		if (!rating || rating < 1 || rating > 5) {
			errors.push('Silakan pilih rating (1-5 bintang)');
		}
		// Check content
		const content = contentInput.value.trim();
		if (!content) {
			errors.push('Silakan tulis review Anda');
		} else if (content.length < 10) {
			errors.push('Review Anda harus minimal 10 karakter');
		} else if (content.length > 5000) {
			errors.push('Review Anda tidak boleh melebihi 5000 karakter');
		}
		return errors;
	}
	function displayErrors(errors) {
		if (errors.length > 0) {
			errorList.innerHTML = '';
			errors.forEach(function(error) {
				const li = document.createElement('li');
				li.textContent = '- ' + error;
				errorList.appendChild(li);
			});
			errorAlert.classList.remove('hidden');
			return false;
		} else {
			errorAlert.classList.add('hidden');
			return true;
		}
	}
	// Add form submission validation
	form.addEventListener('submit', function(e) {
		const errors = validateForm();
		if (!displayErrors(errors)) {
			e.preventDefault();
			// Scroll to error
			errorAlert.scrollIntoView({ behavior: 'smooth', block: 'center' });
		} else {
			// Add callback URL to form action if it exists
			const callbackUrl = '{{ callback_url|escapejs }}';
			if (callbackUrl && !form.action.includes('next=')) {
				form.action = (form.action || window.location.pathname) + '?next=' + encodeURIComponent(callbackUrl);
			}
		}
	});
	// Real-time validation feedback
	contentInput.addEventListener('input', function() {
		const content = contentInput.value.trim();
		let feedback = '';
		if (content.length === 0) {
			feedback = '0/5000 karakter';
		} else if (content.length < 10) {
			feedback = content.length + '/5000 (minimal 10 karakter)';
		} else {
			feedback = content.length + '/5000 karakter';
		}
		// Update character counter (can be displayed near the textarea)
		console.log('Content length:', feedback);
	});
	stars.forEach(function (star) {
		star.addEventListener('click', function () {
			const value = parseInt(star.dataset.value, 10);
			ratingInput.value = value;
			syncStars(value);
			// Clear rating error when a rating is selected
			errorAlert.classList.add('hidden');
		});
		star.addEventListener('keydown', function (event) {
			if (event.key === 'Enter' || event.key === ' ') {
				event.preventDefault();
				star.click();
			}
		});
		star.setAttribute('tabindex', '0');
	});
	// Initialize stars with current rating
	syncStars(parseInt(ratingInput.value, 10));
	// Checkbox functionality
	const checkbox = document.getElementById('is_anonymous_input');
	const checkmark = document.getElementById('checkbox-checkmark');
	checkbox.addEventListener('change', function() {
		if (checkbox.checked) {
			checkmark.classList.remove('opacity-0');
			checkmark.classList.add('opacity-100');
		} else {
			checkmark.classList.remove('opacity-100');
			checkmark.classList.add('opacity-0');
		}
	});
});
{% if is_edit %}
// Modal functions
function openDeleteModal() {
	const modal = document.getElementById('delete-modal');
	modal.classList.remove('hidden');
	modal.classList.add('flex');
	document.body.classList.add('overflow-hidden');
}
function closeDeleteModal() {
	const modal = document.getElementById('delete-modal');
	modal.classList.add('hidden');
	modal.classList.remove('flex');
	document.body.classList.remove('overflow-hidden');
}
function confirmDelete() {
	document.getElementById('delete-form').submit();
}
// Close modal on escape key
document.addEventListener('keydown', function(event) {
	if (event.key === 'Escape') {
		closeDeleteModal();
	}
});
// Close modal on backdrop click
document.getElementById('delete-modal').addEventListener('click', function(event) {
	if (event.target === this) {
		closeDeleteModal();
	}
});
{% endif %}
</script>
````

## File: reviews/admin.py
````python

````

## File: reviews/apps.py
````python
class ReviewsConfig(AppConfig)
⋮----
default_auto_field = 'django.db.models.BigAutoField'
name = 'reviews'
````

## File: reviews/forms.py
````python
class ReviewForm(forms.ModelForm)
⋮----
class Meta
⋮----
model = Review
fields = ['rating', 'content', 'is_anonymous']
widgets = {
labels = {
def clean(self)
⋮----
cleaned_data = super().clean()
rating = cleaned_data.get('rating')
content = cleaned_data.get('content')
````

## File: reviews/models.py
````python
class Review(models.Model)
⋮----
course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='reviews')
booking = models.OneToOneField(Booking, on_delete=models.CASCADE, related_name='review')
user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reviews')
coach = models.ForeignKey(CoachProfile, on_delete=models.CASCADE, related_name='reviews')
is_anonymous = models.BooleanField(default=False)
rating = models.PositiveIntegerField()
content = models.TextField()
created_at = models.DateTimeField(auto_now_add=True)
updated_at = models.DateTimeField(auto_now=True)
def save(self, *args, **kwargs)
def update_ratings(self)
⋮----
course_avg = Review.objects.filter(course=self.course).aggregate(
course_count = Review.objects.filter(course=self.course).count()
⋮----
coach_avg = Review.objects.filter(coach=self.coach).aggregate(
coach_count = Review.objects.filter(coach=self.coach).count()
⋮----
def __str__(self)
````

## File: reviews/urls.py
````python
app_name = "reviews"
urlpatterns = [
````

## File: reviews/views.py
````python
@login_required(login_url='/login')
def create_review(request, booking_id)
⋮----
booking = Booking.objects.get(pk=booking_id)
⋮----
callback_url = request.GET.get('next', 'main:show_main')
⋮----
form = ReviewForm(request.POST)
⋮----
review = form.save(commit=False)
⋮----
form = ReviewForm()
ctx = {
⋮----
@login_required(login_url='/login')
def edit_review(request, review_id)
⋮----
review = Review.objects.get(pk=review_id)
⋮----
form = ReviewForm(request.POST, instance=review)
⋮----
form = ReviewForm(instance=review)
⋮----
@login_required(login_url='/login')
def delete_review(request, review_id)
````

## File: schedule/migrations/0001_initial.py
````python
class Migration(migrations.Migration)
⋮----
initial = True
dependencies = [
operations = [
````

## File: schedule/templates/schedule/_availability_modal.html
````html
<div id="availabilityModal" class="fixed inset-0 bg-gray-900 bg-opacity-50 hidden z-50 flex items-center justify-center">
    <div class="bg-white rounded-lg shadow-xl max-w-2xl w-full mx-4 max-h-[90vh] overflow-hidden flex flex-col">
        <div class="bg-primary text-white px-6 py-4 flex justify-between items-center">
            <h2 class="text-xl font-bold">Atur Ketersediaan</h2>
            <button type="button" onclick="closeAvailabilityModal()" class="text-white hover:text-gray-200">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
            </button>
        </div>
        <div class="p-6 overflow-y-auto flex-1">
            <div class="mb-6">
                <label for="availabilityDate" class="block text-sm font-semibold text-gray-700 mb-2">
                    Pilih Tanggal
                </label>
                <input
                    type="date"
                    id="availabilityDate"
                    class="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-primary focus:border-primary"
                    min="{{ today|date:'Y-m-d' }}"
                >
            </div>
            <div class="mb-6">
                <div class="flex justify-between items-center mb-3">
                    <label class="block text-sm font-semibold text-gray-700">
                        Rentang Waktu Tersedia
                    </label>
                    <button
                        type="button"
                        onclick="addTimeRange()"
                        class="text-sm bg-green-50 text-primary hover:bg-green-100 px-3 py-1 rounded-md font-medium transition-colors flex items-center gap-1"
                    >
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                        </svg>
                        Tambah Rentang
                    </button>
                </div>
                <div id="timeRangesContainer" class="space-y-3">
                    <div class="text-sm text-gray-500 text-center py-4" id="noRangesMessage">
                        Pilih tanggal untuk melihat atau menambah rentang waktu
                    </div>
                </div>
            </div>
            <div id="modalMessage" class="hidden mb-4"></div>
        </div>
        <div class="bg-gray-50 px-6 py-4 flex justify-between gap-3">
            <button
                type="button"
                onclick="deleteAllRanges()"
                id="deleteAllBtn"
                class="px-4 py-2 border border-red-300 text-red-600 rounded-md hover:bg-red-50 font-medium transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                disabled
            >
                Hapus Semua
            </button>
            <div class="flex gap-3">
                <button
                    type="button"
                    onclick="closeAvailabilityModal()"
                    class="px-4 py-2 border border-gray-300 text-gray-700 rounded-md hover:bg-gray-50 font-medium transition-colors"
                >
                    Batal
                </button>
                <button
                    type="button"
                    onclick="saveAvailability()"
                    id="saveBtn"
                    class="px-6 py-2 bg-primary text-white rounded-md hover:bg-green-600 font-medium transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                    disabled
                >
                    Simpan
                </button>
            </div>
        </div>
    </div>
</div>
<template id="timeRangeTemplate">
    <div class="time-range-item flex items-center gap-3 p-3 bg-gray-50 rounded-md">
        <div class="flex-1 flex items-center gap-3">
            <div class="flex-1">
                <label class="block text-xs text-gray-600 mb-1">Mulai</label>
                <input
                    type="time"
                    class="range-start w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:ring-2 focus:ring-primary focus:border-primary"
                    required
                >
            </div>
            <div class="text-gray-400 mt-5">—</div>
            <div class="flex-1">
                <label class="block text-xs text-gray-600 mb-1">Selesai</label>
                <input
                    type="time"
                    class="range-end w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:ring-2 focus:ring-primary focus:border-primary"
                    required
                >
            </div>
        </div>
        <button
            type="button"
            onclick="removeTimeRange(this)"
            class="text-red-500 hover:text-red-700 p-2 rounded-md hover:bg-red-50 transition-colors mt-5"
            title="Hapus rentang ini"
        >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
            </svg>
        </button>
    </div>
</template>
````

## File: schedule/admin.py
````python
@admin.register(CoachAvailability)
class CoachAvailabilityAdmin(admin.ModelAdmin)
⋮----
list_display = ['id', 'coach', 'date', 'start_time', 'end_time', 'created_at']
list_filter = ['date', 'coach']
search_fields = ['coach__user__username', 'coach__user__first_name', 'coach__user__last_name']
ordering = ['-date', 'start_time']
date_hierarchy = 'date'
readonly_fields = ['created_at', 'updated_at']
fieldsets = (
⋮----
@admin.register(ScheduleSlot)
class ScheduleSlotAdmin(admin.ModelAdmin)
⋮----
list_display = ['id', 'coach', 'date', 'start_time', 'end_time', 'is_available', 'created_at']
list_filter = ['is_available', 'date', 'coach']
⋮----
actions = ['mark_as_available', 'mark_as_unavailable', 'duplicate_to_next_week']
def mark_as_available(self, request, queryset)
⋮----
updated = queryset.update(is_available=True)
⋮----
def mark_as_unavailable(self, request, queryset)
⋮----
updated = queryset.update(is_available=False)
⋮----
def duplicate_to_next_week(self, request, queryset)
⋮----
count = 0
⋮----
new_date = slot.date + timedelta(days=7)
````

## File: schedule/apps.py
````python
class ScheduleConfig(AppConfig)
⋮----
default_auto_field = 'django.db.models.BigAutoField'
name = 'schedule'
````

## File: schedule/models.py
````python
class CoachAvailability(models.Model)
⋮----
coach = models.ForeignKey(
date = models.DateField(help_text="Specific date for this availability")
start_time = models.TimeField(help_text="Start time of availability range")
end_time = models.TimeField(help_text="End time of availability range")
created_at = models.DateTimeField(auto_now_add=True)
updated_at = models.DateTimeField(auto_now=True)
class Meta
⋮----
ordering = ['date', 'start_time']
indexes = [
verbose_name_plural = "Coach Availabilities"
def clean(self)
def save(self, *args, **kwargs)
def __str__(self)
class ScheduleSlot(models.Model)
⋮----
coach = models.ForeignKey('user_profile.CoachProfile', on_delete=models.CASCADE, related_name='schedule_slots')
date = models.DateField(help_text="Specific date for this schedule")
start_time = models.TimeField()
end_time = models.TimeField()
is_available = models.BooleanField(default=True)
⋮----
unique_together = ['coach', 'date', 'start_time']
````

## File: schedule/urls.py
````python
app_name = 'schedule'
urlpatterns = [
````

## File: schedule/views.py
````python
@login_required
@require_http_methods(["POST"])
def api_availability_upsert(request)
⋮----
coach = get_object_or_404(CoachProfile, user=request.user)
data = json.loads(request.body)
date_str = data.get('date')
ranges = data.get('ranges', [])
mode = data.get('mode', 'replace')
⋮----
target_date = datetime.strptime(date_str, '%Y-%m-%d').date()
⋮----
existing_availabilities = CoachAvailability.objects.filter(
existing_intervals = list(existing_availabilities)
⋮----
existing_intervals = []
new_intervals = []
⋮----
start_str = range_data.get('start')
end_str = range_data.get('end')
⋮----
start_time = datetime.strptime(start_str, '%H:%M').time()
end_time = datetime.strptime(end_str, '%H:%M').time()
⋮----
all_intervals = existing_intervals + new_intervals
original_count = len(all_intervals)
⋮----
all_intervals = new_intervals
original_count = len(new_intervals)
merged = merge_intervals(all_intervals)
merged_count = len(merged)
⋮----
availabilities = [
⋮----
merged_intervals_response = [
⋮----
message = f'Availability updated for {date_str}. {original_count} interval(s) merged into {merged_count}.'
⋮----
message = f'Availability updated for {date_str}. {merged_count} interval(s) saved.'
⋮----
@login_required
@require_http_methods(["GET"])
def api_availability_list(request)
⋮----
date_str = request.GET.get('date')
⋮----
availabilities = CoachAvailability.objects.filter(
ranges = [
⋮----
@login_required
@require_http_methods(["DELETE"])
def api_availability_delete(request)
````

## File: static/css/global.css
````css
.quicksand {
````

## File: static/css/payment.css
````css
.payment-method-card:has(input:checked) {
````

## File: static/js/payment-callback.js
````javascript
function getCSRFToken() {
⋮----
const cookies = document.cookie.split(';');
⋮----
const cookie = cookies[i].trim();
if (cookie.substring(0, name.length + 1) === (name + '=')) {
cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
⋮----
// Check payment status
function checkPaymentStatus(paymentStatusUrl) {
fetch(paymentStatusUrl + '?refresh=true', {
⋮----
.then(response => response.json())
.then(data => {
⋮----
location.reload();
⋮----
.catch(error => console.error('Error:', error));
⋮----
function showCancelConfirmation() {
const modal = document.getElementById('cancel-confirmation-modal');
⋮----
modal.classList.remove('hidden');
⋮----
function closeCancelModal() {
⋮----
modal.classList.add('hidden');
⋮----
function confirmCancelBooking(bookingId, dashboardUrl) {
fetch(`/booking/api/booking/${bookingId}/cancel/`, {
⋮----
'X-CSRFToken': getCSRFToken()
⋮----
showToast('Booking berhasil dibatalkan!', 'success');
setTimeout(() => {
⋮----
showToast('Gagal membatalkan booking: ' + (data.message || 'Unknown error'), 'error');
closeCancelModal();
⋮----
.catch(error => {
console.error('Error:', error);
showToast('Terjadi kesalahan saat membatalkan booking', 'error');
⋮----
document.addEventListener('DOMContentLoaded', function() {
⋮----
document.addEventListener('click', function(e) {
````

## File: static/js/payment-method.js
````javascript
document.addEventListener('DOMContentLoaded', function() {
const paymentForm = document.getElementById('payment-form');
⋮----
paymentForm.addEventListener('submit', function(e) {
e.preventDefault();
⋮----
const payButton = document.getElementById('pay-button');
const selectedMethod = form.querySelector('input[name="payment_method"]:checked');
⋮----
showToast('Silakan pilih metode pembayaran', 'error');
⋮----
const formData = new FormData(form);
fetch(form.action, {
⋮----
'X-CSRFToken': form.querySelector('[name=csrfmiddlewaretoken]').value
⋮----
.then(response => response.json())
.then(data => {
⋮----
showToast('Inisiasi pembayaran gagal: ' + (data.error || 'Kesalahan tidak diketahui'), 'error');
⋮----
.catch(error => {
console.error('Error:', error);
showToast('Terjadi kesalahan. Silakan coba lagi.', 'error');
⋮----
document.querySelectorAll('.payment-method-card input[type="radio"]').forEach(radio => {
radio.addEventListener('change', function() {
document.querySelectorAll('.payment-method-card').forEach(card => {
card.classList.remove('border-emerald-500', 'bg-green-50');
⋮----
this.closest('.payment-method-card').classList.add('border-emerald-500', 'bg-green-50');
````

## File: static/js/schedule-availability.js
````javascript
function getCookie(name) {
⋮----
const cookies = document.cookie.split(';');
⋮----
const cookie = cookies[i].trim();
if (cookie.substring(0, name.length + 1) === (name + '=')) {
cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
⋮----
const csrftoken = getCookie('csrftoken');
function openAvailabilityModal() {
const modal = document.getElementById('availabilityModal');
modal.classList.remove('hidden');
const today = new Date().toISOString().split('T')[0];
const dateInput = document.getElementById('availabilityDate');
⋮----
loadAvailabilityForDate(dateInput.value);
⋮----
function closeAvailabilityModal() {
⋮----
modal.classList.add('hidden');
const container = document.getElementById('timeRangesContainer');
⋮----
document.getElementById('saveBtn').disabled = true;
document.getElementById('deleteAllBtn').disabled = true;
hideModalMessage();
⋮----
function addTimeRange(startTime = '', endTime = '') {
const template = document.getElementById('timeRangeTemplate');
⋮----
const noRangesMsg = document.getElementById('noRangesMessage');
⋮----
noRangesMsg.remove();
⋮----
const clone = template.content.cloneNode(true);
⋮----
clone.querySelector('.range-start').value = startTime;
⋮----
clone.querySelector('.range-end').value = endTime;
⋮----
container.appendChild(clone);
document.getElementById('saveBtn').disabled = false;
⋮----
function removeTimeRange(button) {
⋮----
const item = button.closest('.time-range-item');
item.remove();
if (container.querySelectorAll('.time-range-item').length === 0) {
⋮----
async function loadAvailabilityForDate(date) {
⋮----
const response = await fetch(`/schedule/api/availability/?date=${date}`, {
⋮----
const data = await response.json();
⋮----
throw new Error(data.error || 'Failed to load availability');
⋮----
// Add ranges from server
⋮----
data.ranges.forEach(range => {
addTimeRange(range.start, range.end);
⋮----
document.getElementById('deleteAllBtn').disabled = false;
⋮----
console.error('Error loading availability:', error);
showModalMessage('Gagal memuat ketersediaan: ' + error.message, 'error');
⋮----
async function saveAvailability() {
const date = document.getElementById('availabilityDate').value;
⋮----
showModalMessage('Pilih tanggal terlebih dahulu', 'error');
⋮----
const rangeItems = document.querySelectorAll('.time-range-item');
⋮----
const start = item.querySelector('.range-start').value;
const end = item.querySelector('.range-end').value;
⋮----
showModalMessage('Semua waktu mulai dan selesai harus diisi', 'error');
⋮----
showModalMessage('Waktu selesai harus lebih besar dari waktu mulai', 'error');
⋮----
ranges.push({ start, end });
⋮----
showModalMessage('Tambahkan minimal satu rentang waktu', 'error');
⋮----
const saveBtn = document.getElementById('saveBtn');
⋮----
const response = await fetch('/schedule/api/availability/upsert/', {
⋮----
body: JSON.stringify({ date, ranges }),
⋮----
throw new Error(data.error || 'Failed to save availability');
⋮----
showModalMessage(message, 'success');
⋮----
data.merged_intervals.forEach(range => {
⋮----
// Show merge notification if intervals were merged
⋮----
setTimeout(() => {
showModalMessage(
⋮----
console.error('Error saving availability:', error);
showModalMessage('Gagal menyimpan: ' + error.message, 'error');
⋮----
async function deleteAllRanges() {
⋮----
if (!confirm(`Hapus semua ketersediaan untuk ${date}?`)) {
⋮----
throw new Error(data.error || 'Failed to delete availability');
⋮----
showModalMessage(data.message, 'success');
⋮----
console.error('Error deleting availability:', error);
showModalMessage('Gagal menghapus: ' + error.message, 'error');
⋮----
function showModalMessage(message, type = 'info') {
const messageEl = document.getElementById('modalMessage');
messageEl.classList.remove('hidden', 'bg-red-100', 'text-red-700', 'bg-green-100', 'text-green-700', 'bg-blue-100', 'text-blue-700');
⋮----
messageEl.classList.add('bg-red-100', 'text-red-700');
⋮----
messageEl.classList.add('bg-green-100', 'text-green-700');
⋮----
messageEl.classList.add('bg-blue-100', 'text-blue-700');
⋮----
messageEl.classList.add('p-3', 'rounded-md', 'text-sm', 'font-medium');
⋮----
function hideModalMessage() {
⋮----
messageEl.classList.add('hidden');
⋮----
document.addEventListener('DOMContentLoaded', function() {
⋮----
dateInput.addEventListener('change', function() {
loadAvailabilityForDate(this.value);
⋮----
modal.addEventListener('click', function(e) {
⋮----
closeAvailabilityModal();
````

## File: static/js/toast.js
````javascript
function showToast(message, type = 'success') {
let toastContainer = document.getElementById('toast-container');
⋮----
toastContainer = document.createElement('div');
⋮----
document.body.appendChild(toastContainer);
⋮----
const toast = document.createElement('div');
⋮----
<div class="${bgColor} rounded-lg shadow-2xl p-4 flex items-center gap-3 min-w-[320px] max-w-md border-l-4 ${iconColor.replace('text-', 'border-')}">
⋮----
toastContainer.appendChild(toast);
setTimeout(() => {
toast.classList.remove('translate-x-full', 'opacity-0');
⋮----
toast.classList.add('translate-x-full', 'opacity-0');
⋮----
toast.remove();
⋮----
toastContainer.remove();
````

## File: user_profile/migrations/0001_initial.py
````python
class Migration(migrations.Migration)
⋮----
initial = True
dependencies = [
operations = [
````

## File: user_profile/templates/coach_profile.html
````html
{% extends 'base.html' %}
{% load static %}
{% block title %}Edit Coach Profile - MamiCoach{% endblock %}
{% block content %}
<div class="bg-gray-50 min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4">
        <div class="mb-4">
            <a href="{% url 'user_profile:dashboard_coach' %}" id="backButton"
               class="inline-flex items-center text-primary hover:text-green-600 text-sm font-medium">
                <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                </svg>
                Kembali ke Dashboard
            </a>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6">
            <h1 class="text-2xl font-bold text-gray-800 mb-6">Edit Profil Coach</h1>
            <form method="POST" enctype="multipart/form-data" id="editProfileForm">
                {% csrf_token %}
                <div class="mb-6 text-center">
                    <div class="inline-block relative">
                        {% if coach_profile.profile_image %}
                        <img src="{{ coach_profile.image_url }}"
                             alt="{{ user.get_full_name }}"
                             id="profileImagePreview"
                             class="w-32 h-32 rounded-full object-cover bg-gray-300 mx-auto">
                        {% else %}
                        <div id="profileImagePreview" class="w-32 h-32 rounded-full bg-gray-300 flex items-center justify-center text-white text-4xl font-bold mx-auto">
                            {{ user.first_name|first }}{{ user.last_name|first }}
                        </div>
                        {% endif %}
                        <label for="profile_image" class="absolute bottom-0 right-0 bg-primary hover:bg-green-600 text-white rounded-full p-2 cursor-pointer transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"></path>
                            </svg>
                        </label>
                    </div>
                    <input type="file" name="profile_image" id="profile_image" accept="image/*" class="hidden">
                    <p class="text-sm text-gray-500 mt-2">Klik ikon kamera untuk mengubah foto profil</p>
                </div>
                <div class="mb-4">
                    <label for="first_name" class="block text-sm font-bold text-gray-700 mb-2">Nama Depan</label>
                    <input type="text" name="first_name" id="first_name"
                           value="{{ user.first_name }}"
                           class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all"
                           required>
                </div>
                <div class="mb-4">
                    <label for="last_name" class="block text-sm font-bold text-gray-700 mb-2">Nama Belakang</label>
                    <input type="text" name="last_name" id="last_name"
                           value="{{ user.last_name }}"
                           class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all"
                           required>
                </div>
                <div class="mb-4">
                    <label class="block text-sm font-bold text-gray-700 mb-2">Keahlian</label>
                    <select id="expertise-dropdown" class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all mb-3">
                        <option value="">-- Pilih keahlian --</option>
                        {% for category in categories %}
                        <option value="{{ category.name }}">{{ category.name }}</option>
                        {% endfor %}
                    </select>
                    <div id="expertise-tags" class="flex flex-wrap gap-2 min-h-[40px]">
                        {% for exp in coach_profile.expertise %}
                        <div class="expertise-tag bg-primary text-white px-4 py-2 rounded-full flex items-center gap-2 text-sm font-semibold shadow-sm" data-sport="{{ exp }}">
                            <span>{{ exp }}</span>
                            <button type="button" onclick="removeExpertiseTag('{{ exp }}')" class="bg-white/20 hover:bg-white/30 text-white rounded-full px-2 py-0.5 text-lg font-bold transition-colors">&times;</button>
                            <input type="hidden" name="expertise[]" value="{{ exp }}">
                        </div>
                        {% endfor %}
                    </div>
                </div>
                <div class="mb-4">
                    <label for="bio" class="block text-sm font-bold text-gray-700 mb-2">Bio</label>
                    <textarea name="bio" id="bio" rows="5"
                              class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all resize-none"
                              required>{{ coach_profile.bio }}</textarea>
                </div>
                <div class="mb-6">
                    <div class="flex justify-between items-center mb-3">
                        <label class="block text-sm font-bold text-gray-700">Certifications</label>
                        <button type="button" id="addCertificationBtn"
                                class="text-primary hover:text-green-600 text-sm font-medium flex items-center gap-1">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                            </svg>
                            Add Certification
                        </button>
                    </div>
                    <div id="newCertificationForm" class="hidden mb-4 p-4 bg-gray-50 rounded-lg border-2 border-primary">
                        <h4 class="text-sm font-semibold text-gray-700 mb-3">Sertifikasi Baru</h4>
                        <div class="space-y-3">
                            <div>
                                <label for="new_cert_name" class="block text-xs font-medium text-gray-700 mb-1">Certificate Name</label>
                                <input type="text" id="new_cert_name"
                                       class="w-full px-3 py-2 bg-white border border-gray-300 rounded-lg text-sm focus:outline-none focus:border-primary focus:ring-2 focus:ring-green-100"
                                       placeholder="e.g., Certified Personal Trainer">
                            </div>
                            <div>
                                <label for="new_cert_url" class="block text-xs font-medium text-gray-700 mb-1">Certificate Link</label>
                                <input type="url" id="new_cert_url"
                                       class="w-full px-3 py-2 bg-white border border-gray-300 rounded-lg text-sm focus:outline-none focus:border-primary focus:ring-2 focus:ring-green-100"
                                       placeholder="https://example.com/certificate.pdf">
                            </div>
                            <div class="flex justify-end gap-2">
                                <button type="button" id="cancelNewCertBtn"
                                        class="px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm font-medium transition-colors">
                                    Cancel
                                </button>
                                <button type="button" id="saveNewCertBtn"
                                        class="px-4 py-2 bg-primary hover:bg-green-600 text-white rounded-lg text-sm font-medium transition-colors">
                                    Add
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="space-y-3" id="certifications-list">
                        {% if certifications %}
                            {% for cert in certifications %}
                            <div class="flex items-center gap-3 p-3 bg-gray-50 rounded-lg border border-gray-200" data-cert-id="{{ cert.id }}">
                                {% if cert.status == 'verified' %}
                                <span class="w-4 h-4 rounded-full bg-primary flex-shrink-0"></span>
                                {% elif cert.status == 'declined' %}
                                <span class="w-4 h-4 rounded-full bg-red-500 flex-shrink-0"></span>
                                {% else %}
                                <span class="w-4 h-4 rounded-full bg-blue-500 flex-shrink-0"></span>
                                {% endif %}
                                <span class="text-sm text-gray-800 flex-grow">{{ cert.certificate_name }}</span>
                                {% if cert.status == 'verified' %}
                                <span class="bg-primary text-white text-xs px-3 py-1 rounded-md font-medium flex-shrink-0">Verified</span>
                                {% elif cert.status == 'declined' %}
                                <span class="bg-red-500 text-white text-xs px-3 py-1 rounded-md font-medium flex-shrink-0">Declined</span>
                                {% else %}
                                <span class="bg-blue-500 text-white text-xs px-3 py-1 rounded-md font-medium flex-shrink-0">Pending</span>
                                {% endif %}
                                <a href="{{ cert.file_url }}" target="_blank" class="text-gray-600 hover:text-gray-800 flex-shrink-0">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
                                    </svg>
                                </a>
                                <button type="button" onclick="deleteCertification({{ cert.id }})" class="text-red-500 hover:text-red-700 flex-shrink-0">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                                    </svg>
                                </button>
                            </div>
                            {% endfor %}
                        {% else %}
                            <p class="text-sm text-gray-400">Belum ada sertifikat yang ditambahkan</p>
                        {% endif %}
                    </div>
                </div>
                <div class="flex justify-end gap-3">
                    <button type="button" id="cancelButton"
                            class="px-6 py-3 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm font-medium transition-colors">
                        Batal
                    </button>
                    <button type="submit"
                            class="px-6 py-3 bg-primary hover:bg-green-600 text-white rounded-lg text-sm font-medium transition-colors">
                        Simpan Perubahan
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<div id="confirmModal" class="hidden fixed inset-0 flex items-center justify-center z-50" style="background-color: rgba(0, 0, 0, 0.25);">
    <div class="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4">
        <h3 class="text-xl font-bold text-gray-800 mb-4" id="modalTitle">Konfirmasi Aksi</h3>
        <p class="text-gray-600 mb-6" id="modalMessage">Apakah Anda yakin?</p>
        <div class="flex justify-end gap-3">
            <button type="button" id="modalCancelBtn"
                    class="px-6 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm font-medium transition-colors">
                Lanjutkan Edit
            </button>
            <button type="button" id="modalConfirmBtn"
                    class="px-6 py-2 bg-primary hover:bg-green-600 text-white rounded-lg text-sm font-medium transition-colors">
                Konfirmasi
            </button>
        </div>
    </div>
</div>
<script>
let formChanged = false;
let selectedExpertise = new Set();
let deletedCertifications = [];
let newCertifications = [];
// Initialize selected expertise
{% for exp in coach_profile.expertise %}
selectedExpertise.add('{{ exp }}');
{% endfor %}
document.getElementById('editProfileForm').addEventListener('input', function() {
    formChanged = true;
});
document.getElementById('editProfileForm').addEventListener('change', function() {
    formChanged = true;
});
// Profile image preview
document.getElementById('profile_image').addEventListener('change', function(e) {
    const file = e.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            const preview = document.getElementById('profileImagePreview');
            if (preview.tagName === 'IMG') {
                preview.src = e.target.result;
            } else {
                const newImg = document.createElement('img');
                newImg.src = e.target.result;
                newImg.className = 'w-32 h-32 rounded-full object-cover bg-gray-300 mx-auto';
                newImg.id = 'profileImagePreview';
                preview.parentNode.replaceChild(newImg, preview);
            }
        };
        reader.readAsDataURL(file);
        formChanged = true;
    }
});
// Expertise dropdown
document.getElementById('expertise-dropdown').addEventListener('change', function() {
    const sport = this.value;
    if (sport && !selectedExpertise.has(sport)) {
        selectedExpertise.add(sport);
        addExpertiseTag(sport);
        this.value = '';
        formChanged = true;
    }
});
function addExpertiseTag(sport) {
    const tagsContainer = document.getElementById('expertise-tags');
    const tag = document.createElement('div');
    tag.className = 'expertise-tag bg-primary text-white px-4 py-2 rounded-full flex items-center gap-2 text-sm font-semibold shadow-sm';
    tag.dataset.sport = sport;
    tag.innerHTML = `
        <span>${sport}</span>
        <button type="button" onclick="removeExpertiseTag('${sport}')" class="bg-white/20 hover:bg-white/30 text-white rounded-full px-2 py-0.5 text-lg font-bold transition-colors">&times;</button>
        <input type="hidden" name="expertise[]" value="${sport}">
    `;
    tagsContainer.appendChild(tag);
}
function removeExpertiseTag(sport) {
    selectedExpertise.delete(sport);
    const tags = document.querySelectorAll('.expertise-tag');
    tags.forEach(tag => {
        if (tag.dataset.sport === sport) {
            tag.remove();
        }
    });
    formChanged = true;
}
function deleteCertification(certId) {
    deletedCertifications.push(certId);
    const certElement = document.querySelector(`[data-cert-id="${certId}"]`);
    if (certElement) {
        certElement.remove();
    }
    formChanged = true;
}
document.getElementById('addCertificationBtn').addEventListener('click', function() {
    document.getElementById('newCertificationForm').classList.remove('hidden');
    this.classList.add('hidden');
});
document.getElementById('cancelNewCertBtn').addEventListener('click', function() {
    document.getElementById('newCertificationForm').classList.add('hidden');
    document.getElementById('addCertificationBtn').classList.remove('hidden');
    document.getElementById('new_cert_name').value = '';
    document.getElementById('new_cert_url').value = '';
});
document.getElementById('saveNewCertBtn').addEventListener('click', function() {
    const certName = document.getElementById('new_cert_name').value.trim();
    const certUrl = document.getElementById('new_cert_url').value.trim();
    if (!certName || !certUrl) {
        showToast('Silakan isi nama sertifikat dan tautan.', 'error');
        return;
    }
    newCertifications.push({
        name: certName,
        url: certUrl
    });
    const certsList = document.getElementById('certifications-list');
    const newCertElement = document.createElement('div');
    newCertElement.className = 'flex items-center gap-3 p-3 bg-gray-50 rounded-lg border border-gray-200';
    newCertElement.dataset.isNew = 'true';
    newCertElement.innerHTML = `
        <span class="w-4 h-4 rounded-full bg-blue-500 flex-shrink-0"></span>
        <span class="text-sm text-gray-800 flex-grow">${certName}</span>
        <span class="bg-blue-500 text-white text-xs px-3 py-1 rounded-md font-medium flex-shrink-0">Pending</span>
        <a href="${certUrl}" target="_blank" class="text-gray-600 hover:text-gray-800 flex-shrink-0">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
            </svg>
        </a>
        <button type="button" onclick="removeNewCertification(this, '${certName}')" class="text-red-500 hover:text-red-700 flex-shrink-0">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
            </svg>
        </button>
    `;
    const noCertsMsg = certsList.querySelector('.text-gray-400');
    if (noCertsMsg) {
        noCertsMsg.remove();
    }
    certsList.appendChild(newCertElement);
    document.getElementById('newCertificationForm').classList.add('hidden');
    document.getElementById('addCertificationBtn').classList.remove('hidden');
    document.getElementById('new_cert_name').value = '';
    document.getElementById('new_cert_url').value = '';
    formChanged = true;
});
function removeNewCertification(button, certName) {
    newCertifications = newCertifications.filter(cert => cert.name !== certName);
    button.closest('.flex').remove();
    const certsList = document.getElementById('certifications-list');
    if (certsList.children.length === 0) {
        certsList.innerHTML = '<p class="text-sm text-gray-400">Belum ada sertifikat yang ditambahkan</p>';
    }
    formChanged = true;
}
// Cancel button
document.getElementById('cancelButton').addEventListener('click', function(e) {
    e.preventDefault();
    showModal(
        'Batal Edit',
        'Apakah Anda yakin ingin membatalkan? Semua perubahan yang belum disimpan akan hilang.',
        function() {
            formChanged = false;
            window.location.href = "{% url 'user_profile:dashboard_coach' %}";
        }
    );
});
// Back button
document.getElementById('backButton').addEventListener('click', function(e) {
    if (formChanged) {
        e.preventDefault();
        showModal(
            'Perubahan Belum Disimpan',
            'Anda memiliki perubahan yang belum disimpan. Ingin lanjutkan edit atau abaikan perubahan?',
            function() {
                formChanged = false;
                window.location.href = "{% url 'user_profile:dashboard_coach' %}";
            }
        );
    }
});
// Browser back button
window.addEventListener('beforeunload', function(e) {
    if (formChanged) {
        e.preventDefault();
        e.returnValue = '';
        return '';
    }
});
// Form submission
document.getElementById('editProfileForm').addEventListener('submit', function(e) {
    e.preventDefault();
    showModal(
        'Simpan Perubahan',
        'Apakah Anda yakin ingin menyimpan perubahan ini?',
        function() {
            // Add deleted certifications to form
            deletedCertifications.forEach(certId => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'deleted_certifications[]';
                input.value = certId;
                document.getElementById('editProfileForm').appendChild(input);
            });
            // Add new certifications to form
            newCertifications.forEach(cert => {
                const nameInput = document.createElement('input');
                nameInput.type = 'hidden';
                nameInput.name = 'new_cert_names[]';
                nameInput.value = cert.name;
                document.getElementById('editProfileForm').appendChild(nameInput);
                const urlInput = document.createElement('input');
                urlInput.type = 'hidden';
                urlInput.name = 'new_cert_urls[]';
                urlInput.value = cert.url;
                document.getElementById('editProfileForm').appendChild(urlInput);
            });
            formChanged = false;
            document.getElementById('editProfileForm').submit();
        }
    );
});
// Modal functions
function showModal(title, message, confirmCallback) {
    document.getElementById('modalTitle').textContent = title;
    document.getElementById('modalMessage').textContent = message;
    document.getElementById('confirmModal').classList.remove('hidden');
    const confirmBtn = document.getElementById('modalConfirmBtn');
    const cancelBtn = document.getElementById('modalCancelBtn');
    // Remove old event listeners
    const newConfirmBtn = confirmBtn.cloneNode(true);
    const newCancelBtn = cancelBtn.cloneNode(true);
    confirmBtn.parentNode.replaceChild(newConfirmBtn, confirmBtn);
    cancelBtn.parentNode.replaceChild(newCancelBtn, cancelBtn);
    // Add new event listeners
    document.getElementById('modalConfirmBtn').addEventListener('click', function() {
        hideModal();
        confirmCallback();
    });
    document.getElementById('modalCancelBtn').addEventListener('click', hideModal);
}
function hideModal() {
    document.getElementById('confirmModal').classList.add('hidden');
}
</script>
{% endblock %}
````

## File: user_profile/templates/dashboard_coach.html
````html
{% extends 'base.html' %}
{% block title %}Coach Dashboard - MamiCoach{% endblock %}
{% block content %}
<div class="bg-gray-50 min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4">
        <div id="coach-profile-card" class="bg-white rounded-lg shadow-md p-6 mb-6">
            <div class="flex items-center justify-center py-12">
                <svg class="animate-spin h-8 w-8 text-primary" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4">Revenue</h2>
            <div class="flex flex-col md:flex-row md:items-center md:justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 gap-4">
                <div class="flex items-center gap-3">
                    <div class="w-12 h-12 bg-gray-200 rounded-full flex items-center justify-center flex-shrink-0">
                        <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                    </div>
                    <div>
                        <h3 class="text-sm font-semibold text-gray-700">Withdrawable Income</h3>
                        <p class="text-2xl font-bold text-gray-800" id="withdrawable-balance">Rp {{ coach_profile.balance_formatted }}</p>
                    </div>
                </div>
                <button class="w-full md:w-auto bg-primary hover:bg-green-600 text-white px-6 py-2 rounded-md text-sm font-medium transition-colors">
                    Request Withdraw
                </button>
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <div class="flex items-center justify-between">
                <h2 class="text-lg font-bold text-gray-800">Your Classes</h2>
                <a href="{% url 'courses_and_coach:my_courses' %}" class="text-primary hover:text-green-600 text-sm font-medium transition-colors">
                    View
                </a>
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4">Create New Class</h2>
            <div class="border-2 border-dashed border-gray-300 rounded-lg p-8 text-center">
                <svg class="w-12 h-12 text-gray-400 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                </svg>
                <h3 class="text-gray-800 font-semibold mb-1">Ready to share your expertise?</h3>
                <p class="text-gray-600 text-sm mb-4">Create a new class and start teaching today</p>
                <a href="{% url 'courses_and_coach:create_course' %}" class="inline-block bg-primary hover:bg-green-600 text-white px-6 py-2 rounded-md text-sm font-medium transition-colors">
                    Create Class
                </a>
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4">In Process Bookings</h2>
            <div id="in-process-bookings" class="space-y-3">
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4">Pending Bookings</h2>
            <div id="pending-bookings" class="space-y-3">
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4">Completed Bookings</h2>
            <div id="completed-bookings" class="space-y-3">
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4">Recently Cancelled Bookings</h2>
            <div id="cancelled-bookings" class="space-y-3">
            </div>
        </div>
    </div>
</div>
<div id="confirmation-modal" class="hidden fixed inset-0 bg-black/50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-lg p-6 max-w-sm w-full mx-4">
        <h3 class="text-lg font-semibold text-gray-800 mb-2" id="modal-title">Konfirmasi</h3>
        <p class="text-gray-600 mb-6" id="modal-message">Apakah Anda yakin?</p>
        <div class="flex gap-3 justify-end">
            <button onclick="closeConfirmationModal()"
                    class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-6 py-2 rounded-md text-sm font-medium transition-colors">
                Batal
            </button>
            <button onclick="confirmAction()"
                    class="bg-primary hover:bg-green-600 text-white px-6 py-2 rounded-md text-sm font-medium transition-colors">
                Konfirmasi
            </button>
        </div>
    </div>
</div>
<script>
let pendingAction = null;
document.addEventListener('DOMContentLoaded', function() {
    fetchCoachProfile();
});
function fetchCoachProfile() {
    fetch('{% url "user_profile:get_coach_profile" %}', {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            renderCoachProfile(data.profile);
        } else {
            showError(data.message || 'Failed to load profile');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showError('An error occurred while loading profile');
    });
}
function showConfirmationModal(title, message, onConfirm) {
    document.getElementById('modal-title').textContent = title;
    document.getElementById('modal-message').textContent = message;
    pendingAction = onConfirm;
    document.getElementById('confirmation-modal').classList.remove('hidden');
}
function closeConfirmationModal() {
    document.getElementById('confirmation-modal').classList.add('hidden');
    pendingAction = null;
}
function confirmAction() {
    if (pendingAction) {
        pendingAction();
    }
    closeConfirmationModal();
}
// Close modal when clicking outside
document.addEventListener('click', function(e) {
    const modal = document.getElementById('confirmation-modal');
    if (e.target === modal) {
        closeConfirmationModal();
    }
});
function renderCoachProfile(profile) {
    const profileCard = document.getElementById('coach-profile-card');
    // Update withdrawable balance
    const balanceElement = document.getElementById('withdrawable-balance');
    if (balanceElement && profile.balance !== undefined) {
        // Format balance as currency
        const balanceInRupiah = new Intl.NumberFormat('id-ID', {
            style: 'currency',
            currency: 'IDR',
            minimumFractionDigits: 0
        }).format(profile.balance);
        balanceElement.textContent = balanceInRupiah;
    }
    let expertiseHTML = '';
    if (profile.expertise && profile.expertise.length > 0) {
        expertiseHTML = profile.expertise.join(', ');
    } else {
        expertiseHTML = '<span class="text-gray-400">No expertise listed</span>';
    }
    let ratingHTML = '';
    if (profile.rating > 0) {
        for (let i = 1; i <= 5; i++) {
            if (i <= profile.rating) {
                ratingHTML += '<span class="text-primary text-lg">★</span>';
            } else {
                ratingHTML += '<span class="text-gray-300 text-lg">★</span>';
            }
        }
    } else {
        ratingHTML = '<span class="text-gray-400 text-sm">No ratings yet</span>';
    }
    let profileImageHTML = '';
    if (profile.profile_image) {
        profileImageHTML = `
            <img src="${profile.profile_image}"
                 alt="${profile.full_name}"
                 class="w-16 h-16 rounded-full object-cover bg-gray-300">
        `;
    } else {
        profileImageHTML = `
            <div class="w-16 h-16 rounded-full bg-gray-300 flex items-center justify-center text-white text-2xl font-bold">
                ${profile.initials}
            </div>
        `;
    }
    let certificationsHTML = '';
    if (profile.certifications && profile.certifications.length > 0) {
        certificationsHTML = profile.certifications.map(cert => {
            let statusColor = '';
            let statusBg = '';
            let statusText = '';
            if (cert.status === 'verified') {
                statusColor = 'bg-primary';
                statusBg = 'bg-primary';
                statusText = 'Verified';
            } else if (cert.status === 'declined') {
                statusColor = 'bg-red-500';
                statusBg = 'bg-red-500';
                statusText = 'Declined';
            } else {
                statusColor = 'bg-blue-500';
                statusBg = 'bg-blue-500';
                statusText = 'Pending';
            }
            return `
                <div class="flex items-center gap-3">
                    <span class="w-4 h-4 rounded-full ${statusColor} flex-shrink-0"></span>
                    <span class="text-sm text-gray-800 flex-grow">${cert.name}</span>
                    <span class="${statusBg} text-white text-xs px-3 py-1 rounded-md font-medium flex-shrink-0">${statusText}</span>
                    <a href="${cert.url}" target="_blank" class="text-gray-600 hover:text-gray-800 flex-shrink-0 ml-1">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
                        </svg>
                    </a>
                </div>
            `;
        }).join('');
    } else {
        certificationsHTML = '<span class="text-sm text-gray-400">No certificates added yet</span>';
    }
    profileCard.innerHTML = `
        <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
            <div class="flex gap-4 flex-grow min-w-0">
                <!-- Profile Image -->
                <div class="flex-shrink-0">
                    ${profileImageHTML}
                </div>
                <!-- Profile Info -->
                <div class="flex-grow min-w-0">
                    <div class="flex flex-col md:flex-row md:items-start md:justify-between mb-3 gap-2">
                        <!-- Name and Expertise -->
                        <div class="min-w-0">
                            <h1 class="text-lg md:text-xl font-bold text-gray-800 mb-1 truncate">${profile.full_name}</h1>
                            <p class="text-sm text-gray-600 line-clamp-2">${expertiseHTML}</p>
                        </div>
                        <!-- Rating -->
                        <div class="flex items-center gap-1 flex-shrink-0">
                            ${ratingHTML}
                        </div>
                    </div>
                    <!-- Bio -->
                    <div class="mb-3">
                        <h3 class="text-sm font-semibold text-gray-700 mb-1">Bio</h3>
                        <p class="text-sm text-gray-600 leading-relaxed break-words line-clamp-3">
                            ${profile.bio}
                        </p>
                    </div>
                    <!-- Certificates -->
                    <div class="mb-3">
                        <h3 class="text-sm font-semibold text-gray-700 mb-2">Certifications</h3>
                        <div class="flex flex-col gap-2.5 overflow-x-auto">
                            ${certificationsHTML}
                        </div>
                    </div>
                    <!-- Edit Profile Button -->
                    <div>
                        <a href="{% url 'user_profile:coach_profile' %}"
                           class="inline-block w-full md:w-auto text-center bg-primary hover:bg-green-600 text-white px-6 py-2 rounded-md text-sm font-medium transition-colors">
                            Edit Profile
                        </a>
                    </div>
                </div>
            </div>
        </div>
    `;
    // Render bookings
    renderInProcessBookings(profile.confirmed_bookings || []);
    renderPendingBookings(profile.pending_bookings || []);
    renderCompletedBookings(profile.completed_bookings || []);
    renderCancelledBookings(profile.cancelled_bookings || []);
}
function renderInProcessBookings(bookings) {
    const container = document.getElementById('in-process-bookings');
    if (!bookings || bookings.length === 0) {
        container.innerHTML = '<p class="text-gray-500 text-sm">No in-process bookings at the moment</p>';
        return;
    }
    container.innerHTML = bookings.map(booking => {
        return `
        <div class="flex flex-col md:flex-row md:items-center md:justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 gap-3 md:gap-4">
            <div class="flex items-center gap-3 flex-grow min-w-0">
                <div class="w-12 h-12 bg-gray-200 rounded flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                </div>
                <div class="min-w-0">
                    <h3 class="text-sm font-semibold text-gray-800 truncate">${booking.course_title} <span class="text-gray-500 font-normal">with ${booking.trainee_name}</span></h3>
                    <p class="text-xs text-gray-500 truncate">${booking.booking_datetime}</p>
                </div>
            </div>
            <div class="flex items-center gap-2 w-full md:w-auto">
                <a href="/chat/presend-booking/${booking.booking_id}/"
                   class="flex-1 md:flex-none bg-white border-2 border-primary hover:bg-green-50 text-primary px-4 py-2 rounded-lg text-sm font-medium transition-colors flex items-center justify-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-message-circle-icon lucide-message-circle">
                        <path d="M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719"/>
                    </svg>
                    <span class="hidden sm:inline">Chat</span>
                </a>
                <button onclick="markBookingAsComplete(${booking.booking_id})"
                        class="flex-1 md:flex-none bg-primary hover:bg-green-600 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
                    Mark as Complete
                </button>
            </div>
        </div>
        `;
    }).join('');
}
function renderPendingBookings(bookings) {
    const container = document.getElementById('pending-bookings');
    if (!bookings || bookings.length === 0) {
        container.innerHTML = '<p class="text-gray-500 text-sm">No pending bookings at the moment</p>';
        return;
    }
    container.innerHTML = bookings.map(booking => `
        <div class="flex flex-col md:flex-row md:items-center md:justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 gap-3 md:gap-4">
            <div class="flex items-center gap-3 flex-grow min-w-0">
                <div class="w-12 h-12 bg-gray-200 rounded flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                    </svg>
                </div>
                <div class="min-w-0">
                    <h3 class="text-sm font-semibold text-gray-800 truncate">${booking.course_title} <span class="text-gray-500 font-normal">with ${booking.trainee_name}</span></h3>
                    <p class="text-xs text-gray-500 truncate">${booking.booking_datetime}</p>
                </div>
            </div>
            <div class="flex items-center gap-2 w-full md:w-auto">
                <button onclick="confirmBooking(${booking.booking_id})"
                        class="flex-1 md:flex-none bg-primary hover:bg-green-600 text-white px-6 py-2 rounded-md text-sm font-medium transition-colors">
                    Accept
                </button>
                <button onclick="declineBooking(${booking.booking_id})"
                        class="flex-1 md:flex-none bg-red-500 hover:bg-red-600 text-white px-6 py-2 rounded-md text-sm font-medium transition-colors">
                    Decline
                </button>
            </div>
        </div>
    `).join('');
}
function renderCompletedBookings(bookings) {
    const container = document.getElementById('completed-bookings');
    if (!bookings || bookings.length === 0) {
        container.innerHTML = '<p class="text-gray-500 text-sm">No completed bookings yet</p>';
        return;
    }
    container.innerHTML = bookings.map(booking => `
        <div class="flex flex-col md:flex-row md:items-center md:justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 gap-3 md:gap-4">
            <div class="flex items-center gap-3 flex-grow min-w-0">
                <div class="w-12 h-12 bg-gray-200 rounded flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                </div>
                <div class="min-w-0">
                    <h3 class="text-sm font-semibold text-gray-800 truncate">${booking.course_title} <span class="text-gray-500 font-normal">with ${booking.trainee_name}</span></h3>
                    <p class="text-xs text-gray-500 truncate">${booking.booking_datetime}</p>
                </div>
            </div>
            <div class="w-full md:w-auto md:ml-4">
                <span class="block text-center bg-green-100 text-primary px-6 py-2 rounded-md text-sm font-medium">
                    Completed
                </span>
            </div>
        </div>
    `).join('');
}
function renderCancelledBookings(bookings) {
    const container = document.getElementById('cancelled-bookings');
    if (!bookings || bookings.length === 0) {
        container.innerHTML = '<p class="text-gray-500 text-sm">No cancelled bookings</p>';
        return;
    }
    container.innerHTML = bookings.map(booking => `
        <div class="flex flex-col md:flex-row md:items-center md:justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 gap-3 md:gap-4">
            <div class="flex items-center gap-3 flex-grow min-w-0">
                <div class="w-12 h-12 bg-gray-200 rounded flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                </div>
                <div class="min-w-0">
                    <h3 class="text-sm font-semibold text-gray-800 truncate">${booking.course_title} <span class="text-gray-500 font-normal">with ${booking.trainee_name}</span></h3>
                    <p class="text-xs text-gray-500 truncate">${booking.booking_datetime}</p>
                </div>
            </div>
            <div class="w-full md:w-auto md:ml-4">
                <span class="block text-center bg-red-100 text-red-600 px-6 py-2 rounded-md text-sm font-medium">
                    Cancelled
                </span>
            </div>
        </div>
    `).join('');
}
function markBookingAsComplete(bookingId) {
    showConfirmationModal(
        'Mark as Complete',
        'Are you sure you want to mark this booking as complete?',
        () => {
            fetch(`/booking/api/booking/${bookingId}/status/`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRFToken': getCSRFToken()
                },
                body: JSON.stringify({ status: 'done' })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Booking marked as complete', 'success');
                    fetchCoachProfile();
                } else {
                    showToast('Failed to update booking: ' + (data.message || data.error || 'Unknown error'), 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('An error occurred while updating the booking', 'error');
            });
        }
    );
}
function confirmBooking(bookingId) {
    showConfirmationModal(
        'Confirm Booking',
        'Are you sure you want to confirm this booking?',
        () => {
            fetch(`/booking/api/booking/${bookingId}/status/`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRFToken': getCSRFToken()
                },
                body: JSON.stringify({ status: 'confirmed' })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Booking confirmed', 'success');
                    fetchCoachProfile();
                } else {
                    showToast('Failed to confirm booking: ' + (data.message || data.error || 'Unknown error'), 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('An error occurred while confirming the booking', 'error');
            });
        }
    );
}
function declineBooking(bookingId) {
    showConfirmationModal(
        'Decline Booking',
        'Are you sure you want to decline this booking?',
        () => {
            fetch(`/booking/api/booking/${bookingId}/status/`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRFToken': getCSRFToken()
                },
                body: JSON.stringify({ status: 'canceled' })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Booking declined', 'success');
                    fetchCoachProfile();
                } else {
                    showToast('Failed to decline booking: ' + (data.message || data.error || 'Unknown error'), 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('An error occurred while declining the booking', 'error');
            });
        }
    );
}
function getCSRFToken() {
    const name = 'csrftoken';
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}
function showError(message) {
    const profileCard = document.getElementById('coach-profile-card');
    profileCard.innerHTML = `
        <div class="text-center py-12">
            <svg class="w-16 h-16 text-red-500 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
            <p class="text-gray-600 mb-4">${message}</p>
            <button onclick="fetchCoachProfile()" class="bg-primary hover:bg-green-600 text-white px-6 py-2 rounded-md text-sm font-medium transition-colors">
                Retry
            </button>
        </div>
    `;
}
</script>
{% endblock %}
````

## File: user_profile/templates/dashboard_user.html
````html
{% extends 'base.html' %}
{% load static %}
{% block title %}User Dashboard - MamiCoach{% endblock %}
{% block extra_head %}
<script src="{% static 'js/toast.js' %}"></script>
{% endblock %}
{% block content %}
<div class="bg-gray-50 min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4">
        <div id="user-profile-card" class="bg-white rounded-lg shadow-md p-6 mb-6">
            <div class="flex items-center justify-center py-12">
                <svg class="animate-spin h-8 w-8 text-primary" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4">Unpaid Bookings</h2>
            <div id="unpaid-bookings" class="space-y-3">
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4">In Process Bookings</h2>
            <div id="in-process-bookings" class="space-y-3">
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4">Pending Bookings</h2>
            <div id="pending-bookings" class="space-y-3">
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4">Completed Bookings</h2>
            <div id="completed-bookings" class="space-y-3">
            </div>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h2 class="text-lg font-bold text-gray-800 mb-4">Recently Cancelled Bookings</h2>
            <div id="cancelled-bookings" class="space-y-3">
            </div>
        </div>
    </div>
</div>
<div id="confirmation-modal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-lg p-6 max-w-sm w-full mx-4">
        <h3 class="text-lg font-semibold text-gray-800 mb-2" id="modal-title">Konfirmasi</h3>
        <p class="text-gray-600 mb-6" id="modal-message">Apakah anda yakin?</p>
        <div class="flex gap-3 justify-end">
            <button onclick="closeConfirmationModal()"
                    class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-6 py-2 rounded-md text-sm font-medium transition-colors">
                Batalkan
            </button>
            <button onclick="confirmAction()"
                    class="bg-primary hover:bg-green-600 text-white px-6 py-2 rounded-md text-sm font-medium transition-colors">
                Konfirmasi
            </button>
        </div>
    </div>
</div>
<script>
let pendingAction = null;
document.addEventListener('DOMContentLoaded', function() {
    fetchUserProfile();
});
function fetchUserProfile() {
    fetch('{% url "user_profile:get_user_profile" %}', {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            renderUserProfile(data.profile);
        } else {
            showError(data.message || 'Failed to load profile');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showError('An error occurred while loading profile');
    });
}
function showConfirmationModal(title, message, onConfirm) {
    document.getElementById('modal-title').textContent = title;
    document.getElementById('modal-message').textContent = message;
    pendingAction = onConfirm;
    document.getElementById('confirmation-modal').classList.remove('hidden');
}
function closeConfirmationModal() {
    document.getElementById('confirmation-modal').classList.add('hidden');
    pendingAction = null;
}
function confirmAction() {
    if (pendingAction) {
        pendingAction();
    }
    closeConfirmationModal();
}
// Close modal when clicking outside
document.addEventListener('click', function(e) {
    const modal = document.getElementById('confirmation-modal');
    if (e.target === modal) {
        closeConfirmationModal();
    }
});
function renderUserProfile(profile) {
    const profileCard = document.getElementById('user-profile-card');
    let profileImageHTML = '';
    if (profile.profile_image) {
        profileImageHTML = `
            <img src="${profile.profile_image}"
                 alt="${profile.full_name}"
                 class="w-16 h-16 rounded-full object-cover bg-gray-300">
        `;
    } else {
        profileImageHTML = `
            <div class="w-16 h-16 rounded-full bg-gray-300 flex items-center justify-center text-white text-2xl font-bold">
                ${profile.initials}
            </div>
        `;
    }
    // Render profile card
    profileCard.innerHTML = `
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <div class="flex items-center gap-4">
                <!-- Profile Image -->
                <div class="flex-shrink-0">
                    ${profileImageHTML}
                </div>
                <!-- Name -->
                <div>
                    <h1 class="text-lg md:text-xl font-bold text-gray-800">${profile.full_name}</h1>
                </div>
            </div>
            <!-- Edit Profile Button -->
            <div class="w-full md:w-auto">
                <a href="{% url 'user_profile:user_profile' %}"
                   class="inline-block w-full md:w-auto text-center bg-primary hover:bg-green-600 text-white px-6 py-2 rounded-md text-sm font-medium transition-colors">
                    Edit Profile
                </a>
            </div>
        </div>
    `;
    // Render bookings
    renderUnpaidBookings(profile.pending_bookings || []);
    renderInProcessBookings(profile.confirmed_bookings || []);
    renderPendingBookings(profile.paid_bookings || []);
    renderCompletedBookings(profile.completed_bookings || []);
    renderCancelledBookings(profile.cancelled_bookings || []);
}
function renderUnpaidBookings(bookings) {
    const container = document.getElementById('unpaid-bookings');
    if (!bookings || bookings.length === 0) {
        container.innerHTML = '<p class="text-gray-500 text-sm">No unpaid bookings at the moment</p>';
        return;
    }
    container.innerHTML = bookings.map(booking => `
        <div class="flex flex-col md:flex-row md:items-center md:justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 gap-3 md:gap-4">
            <div class="flex items-center gap-3 flex-grow min-w-0">
                <div class="w-12 h-12 bg-gray-200 rounded flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                </div>
                <div class="min-w-0">
                    <h3 class="text-sm font-semibold text-gray-800 truncate">${booking.course_title} <span class="text-gray-500 font-normal">with ${booking.coach_name}</span></h3>
                    <p class="text-xs text-gray-500 truncate">${booking.booking_datetime}</p>
                </div>
            </div>
            <div class="w-full md:w-auto flex gap-2">
                <a href="${"{% url 'booking:booking_success' booking_id=999 %}".replace('999', booking.booking_id)}"
                   class="flex-1 md:flex-initial text-center bg-amber-500 hover:bg-amber-600 text-white px-6 py-2 rounded-lg text-sm font-semibold transition-colors">
                    Pay Now
                </a>
                <button onclick="showCancelConfirmation(${booking.booking_id})"
                        class="flex-1 md:flex-initial text-center bg-red-500 hover:bg-red-600 text-white px-6 py-2 rounded-lg text-sm font-semibold transition-colors">
                    Cancel
                </button>
            </div>
        </div>
    `).join('');
}
function renderInProcessBookings(bookings) {
    const container = document.getElementById('in-process-bookings');
    if (!bookings || bookings.length === 0) {
        container.innerHTML = '<p class="text-gray-500 text-sm">No in-process bookings at the moment</p>';
        return;
    }
    container.innerHTML = bookings.map(booking => `
        <div class="flex flex-col md:flex-row md:items-center md:justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 gap-3 md:gap-4">
            <div class="flex items-center gap-3 flex-grow min-w-0">
                <div class="w-12 h-12 bg-gray-200 rounded flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                </div>
                <div class="min-w-0">
                    <h3 class="text-sm font-semibold text-gray-800 truncate">${booking.course_title} <span class="text-gray-500 font-normal">with ${booking.coach_name}</span></h3>
                    <p class="text-xs text-gray-500 truncate">${booking.booking_datetime}</p>
                </div>
            </div>
            <div class="w-full md:w-auto">
                ${booking.booking_id ? `
                    <a href="/chat/presend-booking/${booking.booking_id}/"
                       class="flex items-center justify-center gap-2 w-full md:w-auto bg-white border-2 border-primary hover:bg-green-50 text-primary px-4 py-2 rounded-lg text-sm font-medium transition-colors">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-message-circle">
                            <path d="M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719"/>
                        </svg>
                        <span>Chat</span>
                    </a>
                ` : '<span class="text-gray-500 text-sm block text-center md:text-left">No chat available</span>'}
            </div>
        </div>
    `).join('');
}
function renderPendingBookings(bookings) {
    const container = document.getElementById('pending-bookings');
    if (!bookings || bookings.length === 0) {
        container.innerHTML = '<p class="text-gray-500 text-sm">No pending bookings at the moment</p>';
        return;
    }
    container.innerHTML = bookings.map(booking => `
        <div class="flex flex-col md:flex-row md:items-center md:justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 gap-3 md:gap-4">
            <div class="flex items-center gap-3 flex-grow min-w-0">
                <div class="w-12 h-12 bg-gray-200 rounded flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                    </svg>
                </div>
                <div class="min-w-0">
                    <h3 class="text-sm font-semibold text-gray-800 truncate">${booking.course_title} <span class="text-gray-500 font-normal">with ${booking.coach_name}</span></h3>
                    <p class="text-xs text-gray-500 truncate">${booking.booking_datetime}</p>
                </div>
            </div>
            <div class="w-full md:w-auto md:ml-4">
                <span class="block text-center bg-green-100 text-primary px-6 py-2 rounded-lg text-sm font-medium">
                    Waiting for Coach Confirmation
                </span>
            </div>
        </div>
    `).join('');
}
function renderCompletedBookings(bookings) {
    const container = document.getElementById('completed-bookings');
    if (!bookings || bookings.length === 0) {
        container.innerHTML = '<p class="text-gray-500 text-sm">No completed bookings yet</p>';
        return;
    }
    container.innerHTML = bookings.map(booking => `
        <div class="flex flex-col md:flex-row md:items-center md:justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 gap-3 md:gap-4">
            <div class="flex items-center gap-3 flex-grow min-w-0">
                <div class="w-12 h-12 bg-gray-200 rounded flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                </div>
                <div class="min-w-0">
                    <h3 class="text-sm font-semibold text-gray-800 truncate">${booking.course_title} <span class="text-gray-500 font-normal">with ${booking.coach_name}</span></h3>
                    <p class="text-xs text-gray-500 truncate">${booking.booking_datetime}</p>
                </div>
            </div>
            <div class="w-full md:w-auto">
                ${booking.has_review ? `
                    <a href="${"{% url 'reviews:edit_review' review_id=999 %}".replace('999', booking.review_id)}?next={% url 'user_profile:dashboard_user' %}"
                       class="block text-center bg-primary hover:bg-green-600 text-white px-6 py-2 rounded-lg text-sm font-medium transition-colors">
                        Edit Review
                    </a>
                ` : `
                    <a href="${"{% url 'reviews:create_review' booking_id=999 %}".replace('999', booking.booking_id)}?next={% url 'user_profile:dashboard_user' %}"
                       class="block text-center bg-primary hover:bg-green-600 text-white px-6 py-2 rounded-lg text-sm font-medium transition-colors">
                        Review
                    </a>
                `}
            </div>
        </div>
    `).join('');
}
function renderCancelledBookings(bookings) {
    const container = document.getElementById('cancelled-bookings');
    if (!bookings || bookings.length === 0) {
        container.innerHTML = '<p class="text-gray-500 text-sm">No cancelled bookings</p>';
        return;
    }
    container.innerHTML = bookings.map(booking => `
        <div class="flex flex-col md:flex-row md:items-center md:justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 gap-3 md:gap-4">
            <div class="flex items-center gap-3 flex-grow min-w-0">
                <div class="w-12 h-12 bg-gray-200 rounded flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                </div>
                <div class="min-w-0">
                    <h3 class="text-sm font-semibold text-gray-800 truncate">${booking.course_title} <span class="text-gray-500 font-normal">with ${booking.coach_name}</span></h3>
                    <p class="text-xs text-gray-500 truncate">${booking.booking_datetime}</p>
                </div>
            </div>
            <div class="w-full md:w-auto md:ml-4">
                <span class="block text-center bg-red-100 text-red-600 px-6 py-2 rounded-md text-sm font-medium">
                    Cancelled
                </span>
            </div>
        </div>
    `).join('');
}
function getCSRFToken() {
    const name = 'csrftoken';
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}
function showError(message) {
    const profileCard = document.getElementById('user-profile-card');
    profileCard.innerHTML = `
        <div class="text-center py-12">
            <svg class="w-16 h-16 text-red-500 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
            <p class="text-gray-600 mb-4">${message}</p>
            <button onclick="fetchUserProfile()" class="bg-primary hover:bg-green-600 text-white px-6 py-2 rounded-md text-sm font-medium transition-colors">
                Coba lagi
            </button>
        </div>
    `;
}
function showCancelConfirmation(bookingId) {
    const modal = document.getElementById('cancel-confirmation-modal');
    if (!modal) {
        const newModal = document.createElement('div');
        newModal.id = 'cancel-confirmation-modal';
        newModal.className = 'hidden fixed inset-0 bg-black/50 flex items-center justify-center z-50';
        newModal.innerHTML = `
            <div class="bg-white rounded-lg shadow-lg p-6 max-w-sm w-full mx-4">
                <h3 class="text-lg font-semibold text-gray-800 mb-2">Batalkan Booking?</h3>
                <p class="text-gray-600 mb-6">Are you sure you want to cancel this booking? This action cannot be undone.</p>
                <div class="flex gap-3 justify-end">
                    <button onclick="closeCancelModal()"
                            class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-6 py-2 rounded-lg text-sm font-medium transition-colors">
                        Tidak, Kembali
                    </button>
                    <button onclick="confirmCancelBooking()"
                            class="bg-red-600 hover:bg-red-700 text-white px-6 py-2 rounded-lg text-sm font-medium transition-colors">
                        Ya, Batalkan
                    </button>
                </div>
            </div>
        `;
        document.body.appendChild(newModal);
    }
    const modal2 = document.getElementById('cancel-confirmation-modal');
    modal2.classList.remove('hidden');
    modal2.dataset.bookingId = bookingId;
    // Close modal when clicking outside
    modal2.addEventListener('click', function(e) {
        if (e.target === modal2) {
            closeCancelModal();
        }
    });
}
function closeCancelModal() {
    const modal = document.getElementById('cancel-confirmation-modal');
    if (modal) {
        modal.classList.add('hidden');
    }
}
function confirmCancelBooking() {
    const modal = document.getElementById('cancel-confirmation-modal');
    const bookingId = modal.dataset.bookingId;
    fetch(`/booking/api/booking/${bookingId}/cancel/`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRFToken': getCSRFToken()
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('Booking berhasil dibatalkan!', 'success');
            closeCancelModal();
            setTimeout(() => {
                fetchUserProfile();
            }, 1500);
        } else {
            showToast('Gagal membatalkan booking: ' + (data.message || 'Unknown error'), 'error');
            closeCancelModal();
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Terjadi kesalahan saat membatalkan booking', 'error');
        closeCancelModal();
    });
}
</script>
{% endblock %}
````

## File: user_profile/templates/login.html
````html
{% extends 'base.html' %}
{% load static %}
{% block meta %}
<title>Login MamiCoach</title>
{% endblock meta %}
{% block content %}
<div class="min-h-screen bg-gradient-to-br from-green-50 to-green-100 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full">
        <div class="bg-white rounded-2xl shadow-2xl overflow-hidden">
            <div class="p-8 pb-6">
                <div class="text-center mb-6">
                    <div class="flex justify-center mb-4">
                        <img src="{% static 'images/logo.png' %}" alt="MamiCoach Logo" class="h-16 w-auto">
                    </div>
                    <h1 class="text-3xl font-bold text-gray-800 mb-2">Selamat Datang</h1>
                    <p class="text-gray-500">Masuk ke akun MamiCoach Anda</p>
                </div>
                <form id="login-form" method="POST" action="{% url 'user_profile:login' %}">
                    {% csrf_token %}
                    <div class="mb-4">
                        <label for="{{ form.username.id_for_label }}" class="block text-sm font-medium text-gray-700 mb-2">
                            Username
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                </svg>
                            </div>
                            {{ form.username }}
                        </div>
                        {% if form.username.errors %}
                            <p class="mt-1 text-sm text-red-600">{{ form.username.errors|join:", " }}</p>
                        {% endif %}
                    </div>
                    <div class="mb-6">
                        <label for="{{ form.password.id_for_label }}" class="block text-sm font-medium text-gray-700 mb-2">
                            Password
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                                </svg>
                            </div>
                            {{ form.password }}
                            <button type="button" id="togglePasswordPage" class="absolute inset-y-0 right-0 pr-3 flex items-center">
                                <svg id="eyeIconPage" class="h-5 w-5 text-gray-400 hover:text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                                </svg>
                            </button>
                        </div>
                        {% if form.password.errors %}
                            <p class="mt-1 text-sm text-red-600">{{ form.password.errors|join:", " }}</p>
                        {% endif %}
                    </div>
                    <button id="login-submit" type="submit"
                            class="w-full bg-gradient-to-r from-green-500 to-green-600 text-white py-3 rounded-lg font-semibold hover:from-green-600 hover:to-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 transform transition-all duration-200 hover:scale-[1.02] active:scale-[0.98] disabled:opacity-60 disabled:cursor-not-allowed">
                        Masuk
                    </button>
                </form>
            </div>
            <div class="bg-gray-50 px-8 py-6">
                <p class="text-center text-sm text-gray-600 mb-3">Belum punya akun?</p>
                <div class="flex gap-3">
                    <a href="{% url 'user_profile:register' %}"
                       class="flex-1 text-center px-4 py-2.5 border-2 border-primary text-primary rounded-lg font-medium hover:bg-primary hover:text-white transition-all duration-200">
                        Daftar sebagai Trainee
                    </a>
                    <a href="{% url 'user_profile:register_coach' %}"
                       class="flex-1 text-center px-4 py-2.5 border-2 border-primary text-primary rounded-lg font-medium hover:bg-primary hover:text-white transition-all duration-200">
                        Daftar sebagai Coach
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
<style>
    input[type="text"],
    input[type="password"] {
        width: 100%;
        padding: 0.75rem 0.75rem 0.75rem 2.5rem;
        border: 1px solid #d1d5db;
        border-radius: 0.5rem;
        font-size: 0.875rem;
        transition: all 0.2s;
    }
    input[type="text"]:focus,
    input[type="password"]:focus {
        outline: none;
        border-color: #35A753;
        box-shadow: 0 0 0 2px rgba(53, 167, 83, 0.1);
    }
</style>
<script>
    // Handle password visibility toggle
    const togglePasswordPageBtn = document.getElementById('togglePasswordPage');
    const passwordPageInput = document.getElementById('{{ form.password.id_for_label }}');
    const eyeIconPage = document.getElementById('eyeIconPage');
    if (togglePasswordPageBtn && passwordPageInput) {
        togglePasswordPageBtn.addEventListener('click', function() {
            const type = passwordPageInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordPageInput.setAttribute('type', type);
            if (type === 'text') {
                eyeIconPage.innerHTML = `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"></path>`;
            } else {
                eyeIconPage.innerHTML = `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>`;
            }
        });
    }
    // AJAX Login with toast notifications
    (function() {
        const form = document.getElementById('login-form');
        const submitBtn = document.getElementById('login-submit');
        if (!form) return;
        form.addEventListener('submit', async function(e) {
            e.preventDefault();
            // Prepare
            submitBtn.disabled = true;
            const originalText = submitBtn.textContent;
            submitBtn.textContent = 'Loading...';
            try {
                const formData = new FormData(form);
                // Mark this as non-modal form (for backend logic parity)
                formData.append('from_modal', 'false');
                const res = await fetch(form.action || window.location.href, {
                    method: 'POST',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: formData,
                    credentials: 'same-origin'
                });
                const data = await res.json().catch(() => ({}));
                if (res.ok && data.success) {
                    // Success toast then redirect
                    if (window.showToast) {
                        window.showToast(data.message || 'Login berhasil!', 'success');
                    }
                    const redirectUrl = data.redirect_url || '/';
                    setTimeout(() => {
                        window.location.href = redirectUrl;
                    }, 700);
                } else {
                    // Error toast, no redirect
                    const msg = (data && (data.message || data.error)) || 'Username atau password salah.';
                    if (window.showToast) {
                        window.showToast(msg, 'error');
                    }
                }
            } catch (err) {
                if (window.showToast) {
                    window.showToast('Terjadi kesalahan jaringan. Coba lagi.', 'error');
                }
            } finally {
                submitBtn.disabled = false;
                submitBtn.textContent = originalText;
            }
        });
    })();
</script>
{% endblock content %}
````

## File: user_profile/templates/register_coach.html
````html
{% extends 'base.html' %}
{% load static %}
{% block meta %}
<title>Daftar Sebagai Coach - MamiCoach</title>
<style>
    body {
        font-family: 'Quicksand', sans-serif;
    }
    .gradient-bg {
        background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 50%, #bbf7d0 100%);
    }
    .glass-card {
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.5);
    }
    .floating-animation {
        animation: float 6s ease-in-out infinite;
    }
    @keyframes float {
        0%, 100% { transform: translateY(0px); }
        50% { transform: translateY(-20px); }
    }
    .password-toggle {
        cursor: pointer;
        user-select: none;
    }
    .certification-item {
        border: 2px solid #e5e7eb;
        border-radius: 1rem;
        padding: 1.25rem;
        margin-bottom: 1rem;
        background-color: #f9fafb;
        position: relative;
    }
    .expertise-tag {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 9999px;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.875rem;
        font-weight: 600;
        box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
    }
    .expertise-tag button {
        background: rgba(255, 255, 255, 0.2);
        border: none;
        color: white;
        cursor: pointer;
        font-size: 1.125rem;
        line-height: 1;
        padding: 0.125rem 0.375rem;
        border-radius: 9999px;
        font-weight: bold;
        transition: all 0.2s;
    }
    .expertise-tag button:hover {
        background: rgba(255, 255, 255, 0.3);
    }
    .custom-scrollbar::-webkit-scrollbar {
        width: 8px;
    }
    .custom-scrollbar::-webkit-scrollbar-track {
        background: rgba(243, 244, 246, 0.5);
        border-radius: 10px;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        border-radius: 10px;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb:hover {
        background: linear-gradient(135deg, #059669 0%, #047857 100%);
    }
</style>
{% endblock meta %}
{% block content %}
<div class="min-h-screen gradient-bg relative overflow-hidden">
    <div class="absolute top-10 left-10 w-32 h-32 bg-green-400 rounded-full opacity-20 blur-3xl"></div>
    <div class="absolute bottom-20 right-20 w-40 h-40 bg-emerald-400 rounded-full opacity-20 blur-3xl"></div>
    <div class="absolute top-1/2 left-1/4 w-24 h-24 bg-lime-400 rounded-full opacity-10 blur-2xl"></div>
    <div class="container mx-auto px-4 py-8 md:py-12 min-h-screen">
        <div class="w-full max-w-7xl mx-auto">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-12 items-start">
                <div class="order-1 lg:order-1">
                    <a href="/" class="inline-flex items-center text-gray-700 hover:text-green-600 font-medium mb-6 transition-all group">
                        <svg class="w-5 h-5 mr-2 group-hover:-translate-x-1 transition-transform" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"/>
                        </svg>
                        Kembali
                    </a>
                    <div class="mb-6">
                        <div class="inline-block mb-4">
                            <img src="{% static 'images/logo.png' %}" alt="MamiCoach Logo" class="h-12 w-auto">
                        </div>
                        <h1 class="text-3xl sm:text-4xl font-bold text-gray-900 mb-2">Daftar Sebagai Coach!</h1>
                        <p class="text-gray-600">Bergabung sebagai coach profesional dan bantu trainee mencapai goal mereka</p>
                    </div>
                    <div class="glass-card rounded-2xl shadow-2xl overflow-hidden lg:max-h-[65vh]">
                        <div class="overflow-y-auto lg:max-h-[65vh] p-6 sm:p-8 lg:p-10 custom-scrollbar">
                        <div class="mb-8 hidden">
                            <div class="inline-block mb-4">
                                <img src="{% static 'images/logo.png' %}" alt="MamiCoach Logo" class="h-12 w-auto">
                            </div>
                            <h1 class="text-3xl sm:text-4xl font-bold text-gray-900 mb-2">Daftar Sebagai Coach!</h1>
                            <p class="text-gray-600">Bergabung sebagai coach profesional dan bantu trainee mencapai goal mereka</p>
                        </div>
                        {% if messages %}
                        <div class="bg-red-50 border-l-4 border-red-500 rounded-lg p-4 mb-6">
                            {% for message in messages %}
                            <p class="text-red-800 text-sm font-medium">{{ message }}</p>
                            {% endfor %}
                        </div>
                        {% endif %}
                        {% if form.non_field_errors %}
                        <div class="bg-red-50 border-l-4 border-red-500 rounded-lg p-4 mb-6">
                            {% for error in form.non_field_errors %}
                            <p class="text-red-800 text-sm font-medium">{{ error }}</p>
                            {% endfor %}
                        </div>
                        {% endif %}
                        <form method="POST" enctype="multipart/form-data" class="space-y-6" id="registerCoachForm">
                            {% csrf_token %}
                            <div class="border-2 border-green-200 rounded-2xl p-6 bg-green-50/50">
                                <h3 class="text-lg font-bold text-green-700 mb-4 flex items-center gap-2">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                    </svg>
                                    Informasi Akun
                                </h3>
                                <div class="mb-4">
                                    <label for="{{ form.username.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                        Username <span class="text-red-500">*</span>
                                    </label>
                                    <input type="text" name="{{ form.username.name }}" id="{{ form.username.id_for_label }}"
                                           class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all"
                                           value="{{ form.username.value|default:'' }}" required>
                                    {% if form.username.errors %}
                                        <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.username.errors|join:", " }}</span>
                                    {% endif %}
                                </div>
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-4">
                                    <div>
                                        <label for="{{ form.first_name.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                            Nama Depan <span class="text-red-500">*</span>
                                        </label>
                                        <input type="text" name="{{ form.first_name.name }}" id="{{ form.first_name.id_for_label }}"
                                               class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all"
                                               value="{{ form.first_name.value|default:'' }}" required>
                                        {% if form.first_name.errors %}
                                            <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.first_name.errors|join:", " }}</span>
                                        {% endif %}
                                    </div>
                                    <div>
                                        <label for="{{ form.last_name.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                            Nama Belakang <span class="text-red-500">*</span>
                                        </label>
                                        <input type="text" name="{{ form.last_name.name }}" id="{{ form.last_name.id_for_label }}"
                                               class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all"
                                               value="{{ form.last_name.value|default:'' }}" required>
                                        {% if form.last_name.errors %}
                                            <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.last_name.errors|join:", " }}</span>
                                        {% endif %}
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <label for="{{ form.password1.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                        Password <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <input type="password" name="{{ form.password1.name }}" id="{{ form.password1.id_for_label }}"
                                               class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all pr-12"
                                               required>
                                        <button type="button" onclick="togglePassword('{{ form.password1.id_for_label }}')"
                                                class="password-toggle absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                                            <svg id="eye-{{ form.password1.id_for_label }}" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                            </svg>
                                        </button>
                                    </div>
                                    {% if form.password1.errors %}
                                        <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.password1.errors|join:", " }}</span>
                                    {% endif %}
                                    {% if form.password1.help_text %}
                                        <span class="text-gray-500 text-xs mt-1.5 block">{{ form.password1.help_text }}</span>
                                    {% endif %}
                                </div>
                                <div>
                                    <label for="{{ form.password2.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                        Konfirmasi Password <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <input type="password" name="{{ form.password2.name }}" id="{{ form.password2.id_for_label }}"
                                               class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all pr-12"
                                               required>
                                        <button type="button" onclick="togglePassword('{{ form.password2.id_for_label }}')"
                                                class="password-toggle absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                                            <svg id="eye-{{ form.password2.id_for_label }}" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                            </svg>
                                        </button>
                                    </div>
                                    {% if form.password2.errors %}
                                        <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.password2.errors|join:", " }}</span>
                                    {% endif %}
                                </div>
                            </div>
                            <div class="border-2 border-emerald-200 rounded-2xl p-6 bg-emerald-50/50">
                                <h3 class="text-lg font-bold text-emerald-700 mb-4 flex items-center gap-2">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                    </svg>
                                    Profil Coach
                                </h3>
                                <div class="mb-4">
                                    <label for="{{ form.bio.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                        Bio <span class="text-red-500">*</span>
                                    </label>
                                    <textarea name="{{ form.bio.name }}" id="{{ form.bio.id_for_label }}" rows="4"
                                              class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all resize-none"
                                              required>{{ form.bio.value|default:'' }}</textarea>
                                    {% if form.bio.errors %}
                                        <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.bio.errors|join:", " }}</span>
                                    {% endif %}
                                </div>
                                <!-- Expertise -->
                                <div class="mb-4">
                                    <label class="block text-sm font-bold text-gray-700 mb-2">
                                        Keahlian <span class="text-red-500">*</span>
                                    </label>
                                    <p class="text-xs text-gray-600 mb-3">Pilih olahraga dari dropdown - setiap pilihan akan muncul sebagai tag</p>
                                    <select id="expertise-dropdown" class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all">
                                        <option value="">-- Pilih olahraga --</option>
                                        {% for category in categories %}
                                        <option value="{{ category.name }}">{{ category.name }}</option>
                                        {% endfor %}
                                    </select>
                                    <div id="expertise-tags" class="mt-3 flex flex-wrap gap-2 min-h-[40px]">
                                        <!-- Selected expertise tags will appear here -->
                                    </div>
                                </div>
                                <!-- Profile Image -->
                                <div>
                                    <label for="{{ form.profile_image.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                        Foto Profil <span class="text-gray-400 text-xs font-normal">(Opsional)</span>
                                    </label>
                                    <input type="file" name="{{ form.profile_image.name }}" id="{{ form.profile_image.id_for_label }}"
                                           accept="image/*"
                                           class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-green-50 file:text-green-700 hover:file:bg-green-100">
                                    {% if form.profile_image.help_text %}
                                        <span class="text-gray-500 text-xs mt-1.5 block">{{ form.profile_image.help_text }}</span>
                                    {% endif %}
                                    {% if form.profile_image.errors %}
                                        <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.profile_image.errors|join:", " }}</span>
                                    {% endif %}
                                </div>
                            </div>
                            <!-- Certifications Section -->
                            <div class="border-2 border-blue-200 rounded-2xl p-6 bg-blue-50/50">
                                <h3 class="text-lg font-bold text-blue-700 mb-4 flex items-center gap-2">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"/>
                                    </svg>
                                    Sertifikasi <span class="text-gray-400 text-xs font-normal">(Opsional)</span>
                                </h3>
                                <div id="certifications-container">
                                </div>
                                <button type="button" id="add-certification-btn"
                                        class="w-full bg-blue-100 hover:bg-blue-200 text-blue-700 font-semibold py-3 rounded-xl transition-all duration-200 flex items-center justify-center gap-2 mt-3">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                                    </svg>
                                    Tambah Sertifikasi
                                </button>
                            </div>
                            <!-- Submit Button -->
                            <button type="submit" class="w-full bg-gradient-to-r from-green-500 to-emerald-600 hover:from-green-600 hover:to-emerald-700 text-white font-bold py-4 rounded-xl shadow-lg shadow-green-200 hover:shadow-xl hover:shadow-green-300 hover:-translate-y-1 transition-all duration-300">
                                <span class="flex items-center justify-center gap-2">
                                    Daftar Sebagai Coach
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"/>
                                    </svg>
                                </span>
                            </button>
                        </form>
                        <!-- Footer -->
                        <div class="mt-6 text-center">
                            <p class="text-sm text-gray-600">
                                Sudah punya akun?
                                <a href="{% url 'user_profile:login' %}" class="text-green-600 font-bold hover:text-green-700 hover:underline">
                                    Masuk di sini
                                </a>
                            </p>
                        </div>
                        </div>
                    </div>
                </div>
                <div class="order-2 lg:order-2 flex items-center justify-center lg:sticky lg:top-40">
                    <div class="relative w-full max-w-[250px] sm:max-w-[280px] lg:max-w-[320px] mx-auto">
                        <div class="absolute -top-4 -right-4 w-32 h-32 bg-gradient-to-br from-green-200 to-emerald-300 rounded-full opacity-20 blur-3xl"></div>
                        <div class="absolute -bottom-8 -left-8 w-28 h-28 bg-gradient-to-tr from-lime-200 to-green-300 rounded-full opacity-20 blur-3xl"></div>
                        <div class="relative floating-animation">
                            <img src="{% static 'images/register2.png' %}" alt="MamiCoach Coach" class="w-full h-auto relative z-10 drop-shadow-2xl">
                        </div>
                        <div class="hidden lg:flex absolute bottom-4 -right-2 glass-card rounded-xl p-2.5 shadow-lg">
                            <div class="flex items-center gap-2">
                                <div class="bg-green-100 rounded-full p-2">
                                    <svg class="w-4 h-4 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                                    </svg>
                                </div>
                                <div>
                                    <p class="text-lg font-bold text-gray-800">100+</p>
                                    <p class="text-[9px] text-gray-600">Pro Coach</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
// Password toggle function
function togglePassword(fieldId) {
    const field = document.getElementById(fieldId);
    const eyeIcon = document.getElementById('eye-' + fieldId);
    if (field.type === 'password') {
        field.type = 'text';
        eyeIcon.innerHTML = `
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/>
        `;
    } else {
        field.type = 'password';
        eyeIcon.innerHTML = `
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
        `;
    }
}
let selectedExpertise = new Set();
document.getElementById('expertise-dropdown').addEventListener('change', function() {
    const sport = this.value;
    if (sport && !selectedExpertise.has(sport)) {
        selectedExpertise.add(sport);
        addExpertiseTag(sport);
        this.value = '';
    }
});
function addExpertiseTag(sport) {
    const tagsContainer = document.getElementById('expertise-tags');
    const tag = document.createElement('div');
    tag.className = 'expertise-tag';
    tag.dataset.sport = sport;
    tag.innerHTML = `
        <span>${sport}</span>
        <button type="button" onclick="removeExpertiseTag('${sport}')">&times;</button>
        <input type="hidden" name="expertise[]" value="${sport}">
    `;
    tagsContainer.appendChild(tag);
}
function removeExpertiseTag(sport) {
    selectedExpertise.delete(sport);
    const tags = document.querySelectorAll('.expertise-tag');
    tags.forEach(tag => {
        if (tag.dataset.sport === sport) {
            tag.remove();
        }
    });
}
let certCount = 0;
let activeCerts = new Set();
document.getElementById('add-certification-btn').addEventListener('click', function() {
    certCount++;
    activeCerts.add(certCount);
    const container = document.getElementById('certifications-container');
    const certDiv = document.createElement('div');
    certDiv.className = 'certification-item';
    certDiv.id = 'cert-' + certCount;
    const displayNumber = activeCerts.size;
    certDiv.innerHTML = `
        <div class="flex items-center justify-between mb-3">
            <h4 class="font-bold text-gray-700 flex items-center gap-2">
                <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"/>
                </svg>
                Sertifikasi #${displayNumber}
            </h4>
            <button type="button" onclick="removeCert(${certCount})"
                    class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded-lg text-xs font-semibold transition-colors">
                Hapus
            </button>
        </div>
        <div class="space-y-3">
            <div>
                <label class="block text-xs font-bold text-gray-600 mb-1">Nama Sertifikat</label>
                <input type="text" name="certification_name[]"
                       class="w-full px-3 py-2 bg-white border-2 border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition-all">
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-600 mb-1">URL Sertifikat</label>
                <input type="text" name="certification_url[]"
                       class="w-full px-3 py-2 bg-white border-2 border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition-all">
            </div>
        </div>
    `;
    container.appendChild(certDiv);
});
function removeCert(id) {
    const certDiv = document.getElementById('cert-' + id);
    if (certDiv) {
        certDiv.remove();
        activeCerts.delete(id);
        updateCertNumbers();
    }
}
function updateCertNumbers() {
    const container = document.getElementById('certifications-container');
    const certItems = container.querySelectorAll('.certification-item');
    certItems.forEach((item, index) => {
        const heading = item.querySelector('h4');
        if (heading) {
            const textNode = heading.childNodes[heading.childNodes.length - 1];
            textNode.textContent = `Sertifikasi #${index + 1}`;
        }
    });
}
document.addEventListener('DOMContentLoaded', function() {
    const registerCoachForm = document.getElementById('registerCoachForm');
    if (!registerCoachForm) {
        console.error('Register coach form not found!');
        return;
    }
    registerCoachForm.addEventListener('submit', function(e) {
        e.preventDefault();
        console.log('Coach form submitted via AJAX');
        const formData = new FormData(this);
        const submitBtn = this.querySelector('button[type="submit"]');
        const btnSpan = submitBtn.querySelector('span');
        const originalSpanContent = btnSpan.innerHTML;
        submitBtn.disabled = true;
        submitBtn.style.cssText = 'opacity: 0.8 !important; background: linear-gradient(to right, rgb(34, 197, 94), rgb(5, 150, 105)) !important; cursor: not-allowed !important;';
        btnSpan.innerHTML = '<svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg><span style="margin-left: 8px;">Mendaftar...</span>';
        fetch(this.action || window.location.href, {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
            }
        })
        .then(response => {
            console.log('Response status:', response.status);
            if (!response.ok) {
                return response.json().then(err => Promise.reject(err));
            }
            return response.json();
        })
        .then(data => {
            console.log('Success response:', data);
            if (data.success) {
                // Show success toast
                console.log('Calling showToast...');
                if (typeof showToast === 'function') {
                    showToast(data.message, 'success');
                } else {
                    console.error('showToast is not a function!');
                }
                setTimeout(() => {
                    window.location.href = data.redirect_url;
                }, 1500);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            if (error.errors) {
                let errorMessages = [];
                for (const [field, errors] of Object.entries(error.errors)) {
                    errorMessages.push(...errors);
                }
                const errorMsg = errorMessages.join(' ');
                if (typeof showToast === 'function') {
                    showToast(errorMsg, 'error');
                }
            } else {
                if (typeof showToast === 'function') {
                    showToast('Terjadi kesalahan. Silakan coba lagi.', 'error');
                }
            }
            submitBtn.disabled = false;
            submitBtn.style.cssText = '';
            btnSpan.innerHTML = originalSpanContent;
        });
    });
});
</script>
{% endblock content %}
````

## File: user_profile/templates/register.html
````html
{% extends 'base.html' %}
{% load static %}
{% block meta %}
<title>Daftar Sebagai Trainee - MamiCoach</title>
<style>
    body {
        font-family: 'Quicksand', sans-serif;
    }
    .gradient-bg {
        background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 50%, #bbf7d0 100%);
    }
    .glass-card {
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.5);
    }
    .floating-animation {
        animation: float 6s ease-in-out infinite;
    }
    @keyframes float {
        0%, 100% { transform: translateY(0px); }
        50% { transform: translateY(-20px); }
    }
    .password-toggle {
        cursor: pointer;
        user-select: none;
    }
</style>
{% endblock meta %}
{% block content %}
<div class="min-h-screen gradient-bg relative overflow-hidden">
    <div class="absolute top-10 left-10 w-32 h-32 bg-green-400 rounded-full opacity-20 blur-3xl"></div>
    <div class="absolute bottom-20 right-20 w-40 h-40 bg-emerald-400 rounded-full opacity-20 blur-3xl"></div>
    <div class="absolute top-1/2 left-1/4 w-24 h-24 bg-lime-400 rounded-full opacity-10 blur-2xl"></div>
    <div class="container mx-auto px-4 py-8 md:py-12 lg:py-8 min-h-screen flex items-center">
        <div class="w-full max-w-7xl mx-auto">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-12 items-center">
                <div class="order-1 lg:order-1">
                    <a href="/" class="inline-flex items-center text-gray-700 hover:text-green-600 font-medium mb-6 transition-all group">
                        <svg class="w-5 h-5 mr-2 group-hover:-translate-x-1 transition-transform" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"/>
                        </svg>
                        Kembali
                    </a>
                    <div class="glass-card rounded-3xl shadow-2xl p-6 sm:p-8 lg:p-10">
                        <div class="mb-8">
                            <h1 class="text-3xl sm:text-4xl font-bold text-gray-900 mb-2">Daftar Sekarang!</h1>
                            <p class="text-gray-600">Mulai transformasi hidup sehat bersama coach profesional</p>
                        </div>
                        {% if messages %}
                        <div class="bg-red-50 border-l-4 border-red-500 rounded-lg p-4 mb-6">
                            {% for message in messages %}
                            <p class="text-red-800 text-sm font-medium">{{ message }}</p>
                            {% endfor %}
                        </div>
                        {% endif %}
                        <form method="POST" class="space-y-5" id="registerForm">
                            {% csrf_token %}
                            <div>
                                <label for="{{ form.username.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                    Username <span class="text-red-500">*</span>
                                </label>
                                <input type="text" name="{{ form.username.name }}" id="{{ form.username.id_for_label }}"
                                       class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all"
                                       value="{{ form.username.value|default:'' }}" required>
                                {% if form.username.errors %}
                                    <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.username.errors|join:", " }}</span>
                                {% endif %}
                            </div>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div>
                                    <label for="{{ form.first_name.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                        Nama Depan <span class="text-red-500">*</span>
                                    </label>
                                    <input type="text" name="{{ form.first_name.name }}" id="{{ form.first_name.id_for_label }}"
                                           class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all"
                                           value="{{ form.first_name.value|default:'' }}" required>
                                    {% if form.first_name.errors %}
                                        <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.first_name.errors|join:", " }}</span>
                                    {% endif %}
                                </div>
                                <div>
                                    <label for="{{ form.last_name.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                        Nama Belakang <span class="text-red-500">*</span>
                                    </label>
                                    <input type="text" name="{{ form.last_name.name }}" id="{{ form.last_name.id_for_label }}"
                                           class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all"
                                           value="{{ form.last_name.value|default:'' }}" required>
                                    {% if form.last_name.errors %}
                                        <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.last_name.errors|join:", " }}</span>
                                    {% endif %}
                                </div>
                            </div>
                            <div>
                                <label for="{{ form.password1.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                    Password <span class="text-red-500">*</span>
                                </label>
                                <div class="relative">
                                    <input type="password" name="{{ form.password1.name }}" id="{{ form.password1.id_for_label }}"
                                           class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all pr-12"
                                           required>
                                    <button type="button" onclick="togglePassword('{{ form.password1.id_for_label }}')"
                                            class="password-toggle absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                                        <svg id="eye-{{ form.password1.id_for_label }}" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                        </svg>
                                    </button>
                                </div>
                                {% if form.password1.errors %}
                                    <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.password1.errors|join:", " }}</span>
                                {% endif %}
                                {% if form.password1.help_text %}
                                    <span class="text-gray-500 text-xs mt-1.5 block">{{ form.password1.help_text }}</span>
                                {% endif %}
                            </div>
                            <div>
                                <label for="{{ form.password2.id_for_label }}" class="block text-sm font-bold text-gray-700 mb-2">
                                    Konfirmasi Password <span class="text-red-500">*</span>
                                </label>
                                <div class="relative">
                                    <input type="password" name="{{ form.password2.name }}" id="{{ form.password2.id_for_label }}"
                                           class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all pr-12"
                                           required>
                                    <button type="button" onclick="togglePassword('{{ form.password2.id_for_label }}')"
                                            class="password-toggle absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                                        <svg id="eye-{{ form.password2.id_for_label }}" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                        </svg>
                                    </button>
                                </div>
                                {% if form.password2.errors %}
                                    <span class="text-red-600 text-xs mt-1.5 block font-medium">{{ form.password2.errors|join:", " }}</span>
                                {% endif %}
                            </div>
                            <button type="submit" class="w-full bg-gradient-to-r from-green-500 to-emerald-600 hover:from-green-600 hover:to-emerald-700 text-white font-bold py-4 rounded-xl shadow-lg shadow-green-200 hover:shadow-xl hover:shadow-green-300 hover:-translate-y-1 transition-all duration-300 mt-6">
                                <span class="flex items-center justify-center gap-2">
                                    Daftar Sekarang
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"/>
                                    </svg>
                                </span>
                            </button>
                        </form>
                        <div class="mt-6 text-center space-y-4">
                            <p class="text-sm text-gray-600">
                                Sudah punya akun?
                                <a href="{% url 'user_profile:login' %}" class="text-green-600 font-bold hover:text-green-700 hover:underline">
                                    Masuk di sini
                                </a>
                            </p>
                            <a href="{% url 'user_profile:register_coach' %}" class="text-green-600 font-bold hover:text-green-700  hover:underline">
                                Daftar sebagai coach
                            </a>
                        </div>
                    </div>
                </div>
                <div class="order-2 lg:order-2 flex items-center justify-center">
                    <div class="relative w-full max-w-lg lg:max-w-xl">
                        <div class="absolute -top-4 -right-4 w-72 h-72 bg-gradient-to-br from-green-200 to-emerald-300 rounded-full opacity-20 blur-3xl"></div>
                        <div class="absolute -bottom-8 -left-8 w-64 h-64 bg-gradient-to-tr from-lime-200 to-green-300 rounded-full opacity-20 blur-3xl"></div>
                        <div class="relative floating-animation">
                            <img src="{% static 'images/register1.png' %}" alt="MamiCoach Fitness" class="w-full h-auto relative z-10 drop-shadow-2xl">
                        </div>
                        <div class="hidden lg:flex absolute bottom-16 -right-8 glass-card rounded-2xl p-4 shadow-lg">
                            <div class="flex items-center gap-3">
                                <div class="bg-green-100 rounded-full p-3">
                                    <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                                    </svg>
                                </div>
                                <div>
                                    <p class="text-2xl font-bold text-gray-800">500+</p>
                                    <p class="text-xs text-gray-600">Active Trainee</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function togglePassword(fieldId) {
    const field = document.getElementById(fieldId);
    const eyeIcon = document.getElementById('eye-' + fieldId);
    if (field.type === 'password') {
        field.type = 'text';
        eyeIcon.innerHTML = `
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/>
        `;
    } else {
        field.type = 'password';
        eyeIcon.innerHTML = `
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
        `;
    }
}
document.addEventListener('DOMContentLoaded', function() {
    const registerForm = document.getElementById('registerForm');
    if (!registerForm) {
        console.error('Register form not found!');
        return;
    }
    registerForm.addEventListener('submit', function(e) {
        e.preventDefault();
        console.log('Form submitted via AJAX');
        const formData = new FormData(this);
        const submitBtn = this.querySelector('button[type="submit"]');
        const btnSpan = submitBtn.querySelector('span');
        const originalSpanContent = btnSpan.innerHTML;
        submitBtn.disabled = true;
        submitBtn.style.cssText = 'opacity: 0.8 !important; background: linear-gradient(to right, rgb(34, 197, 94), rgb(5, 150, 105)) !important; cursor: not-allowed !important;';
        btnSpan.innerHTML = '<svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg><span style="margin-left: 8px;">Mendaftar...</span>';
        fetch(this.action || window.location.href, {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
            }
        })
        .then(response => {
            console.log('Response status:', response.status);
            if (!response.ok) {
                return response.json().then(err => Promise.reject(err));
            }
            return response.json();
        })
        .then(data => {
            console.log('Success response:', data);
            if (data.success) {
                console.log('Calling showToast...');
                if (typeof showToast === 'function') {
                    showToast(data.message, 'success');
                } else {
                    console.error('showToast is not a function!');
                }
                setTimeout(() => {
                    window.location.href = data.redirect_url;
                }, 1500);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            // Show error messages
            if (error.errors) {
                let errorMessages = [];
                for (const [field, errors] of Object.entries(error.errors)) {
                    errorMessages.push(...errors);
                }
                const errorMsg = errorMessages.join(' ');
                if (typeof showToast === 'function') {
                    showToast(errorMsg, 'error');
                }
            } else {
                if (typeof showToast === 'function') {
                    showToast('Terjadi kesalahan. Silakan coba lagi.', 'error');
                }
            }
            submitBtn.disabled = false;
            submitBtn.style.cssText = '';
            btnSpan.innerHTML = originalSpanContent;
        });
    });
});
</script>
{% endblock content %}
````

## File: user_profile/templates/user_profile.html
````html
{% extends 'base.html' %}
{% load static %}
{% block title %}Edit User Profile - MamiCoach{% endblock %}
{% block content %}
<div class="bg-gray-50 min-h-screen py-8">
    <div class="max-w-4xl mx-auto px-4">
        <div class="mb-4">
            <a href="{% url 'user_profile:dashboard_user' %}" id="backButton"
               class="inline-flex items-center text-primary hover:text-green-600 text-sm font-medium">
                <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                </svg>
                Back to Dashboard
            </a>
        </div>
        <div class="bg-white rounded-lg shadow-md p-6">
            <h1 class="text-2xl font-bold text-gray-800 mb-6">Edit User Profile</h1>
            <form method="POST" enctype="multipart/form-data" id="editProfileForm">
                {% csrf_token %}
                <div class="mb-6 text-center">
                    <div class="inline-block relative">
                        <div id="profileImagePreview" class="w-32 h-32 rounded-full bg-gray-300 flex items-center justify-center text-white text-4xl font-bold mx-auto">
                            {{ user.first_name|first }}{{ user.last_name|first }}
                        </div>
                        <label for="profile_image" class="absolute bottom-0 right-0 bg-primary hover:bg-green-600 text-white rounded-full p-2 cursor-pointer transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"></path>
                            </svg>
                        </label>
                    </div>
                    <input type="file" name="profile_image" id="profile_image" accept="image/*" class="hidden">
                    <p class="text-sm text-gray-500 mt-2">Click camera icon to change profile picture</p>
                </div>
                <div class="mb-4">
                    <label for="first_name" class="block text-sm font-bold text-gray-700 mb-2">First Name</label>
                    <input type="text" name="first_name" id="first_name"
                           value="{{ user.first_name }}"
                           class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all"
                           required>
                </div>
                <div class="mb-6">
                    <label for="last_name" class="block text-sm font-bold text-gray-700 mb-2">Last Name</label>
                    <input type="text" name="last_name" id="last_name"
                           value="{{ user.last_name }}"
                           class="w-full px-4 py-3 bg-white border-2 border-gray-200 rounded-xl text-sm focus:outline-none focus:border-green-500 focus:ring-4 focus:ring-green-100 transition-all"
                           required>
                </div>
                <div class="flex justify-end gap-3">
                    <button type="button" id="cancelButton"
                            class="px-6 py-3 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm font-medium transition-colors">
                        Cancel
                    </button>
                    <button type="submit"
                            class="px-6 py-3 bg-primary hover:bg-green-600 text-white rounded-lg text-sm font-medium transition-colors">
                        Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<div id="confirmModal" class="hidden fixed inset-0 flex items-center justify-center z-50" style="background-color: rgba(0, 0, 0, 0.25);">
    <div class="bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4">
        <h3 class="text-xl font-bold text-gray-800 mb-4" id="modalTitle">Confirm Action</h3>
        <p class="text-gray-600 mb-6" id="modalMessage">Are you sure?</p>
        <div class="flex justify-end gap-3">
            <button type="button" id="modalCancelBtn"
                    class="px-6 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm font-medium transition-colors">
                Continue Editing
            </button>
            <button type="button" id="modalConfirmBtn"
                    class="px-6 py-2 bg-primary hover:bg-green-600 text-white rounded-lg text-sm font-medium transition-colors">
                Confirm
            </button>
        </div>
    </div>
</div>
<script>
let formChanged = false;
// Get CSRF token
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}
// Load current profile image on page load
document.addEventListener('DOMContentLoaded', function() {
    fetch('{% url "user_profile:get_user_profile" %}', {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success && data.profile.profile_image) {
            const preview = document.getElementById('profileImagePreview');
            const newImg = document.createElement('img');
            newImg.src = data.profile.profile_image;
            newImg.className = 'w-32 h-32 rounded-full object-cover bg-gray-300 mx-auto';
            newImg.id = 'profileImagePreview';
            preview.parentNode.replaceChild(newImg, preview);
        }
    })
    .catch(error => {
        console.error('Error loading profile image:', error);
    });
});
// Track form changes
document.getElementById('editProfileForm').addEventListener('input', function() {
    formChanged = true;
});
document.getElementById('editProfileForm').addEventListener('change', function() {
    formChanged = true;
});
// Profile image preview
document.getElementById('profile_image').addEventListener('change', function(e) {
    const file = e.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            const preview = document.getElementById('profileImagePreview');
            if (preview.tagName === 'IMG') {
                preview.src = e.target.result;
            } else {
                const newImg = document.createElement('img');
                newImg.src = e.target.result;
                newImg.className = 'w-32 h-32 rounded-full object-cover bg-gray-300 mx-auto';
                newImg.id = 'profileImagePreview';
                preview.parentNode.replaceChild(newImg, preview);
            }
        };
        reader.readAsDataURL(file);
        formChanged = true;
    }
});
// Cancel button
document.getElementById('cancelButton').addEventListener('click', function(e) {
    e.preventDefault();
    showModal(
        'Cancel Editing',
        'Are you sure you want to cancel? All unsaved changes will be lost.',
        function() {
            formChanged = false;
            window.location.href = "{% url 'user_profile:dashboard_user' %}";
        }
    );
});
// Back button
document.getElementById('backButton').addEventListener('click', function(e) {
    if (formChanged) {
        e.preventDefault();
        showModal(
            'Unsaved Changes',
            'You have unsaved changes. Do you want to continue editing or discard changes?',
            function() {
                formChanged = false;
                window.location.href = "{% url 'user_profile:dashboard_user' %}";
            }
        );
    }
});
// Browser back button
window.addEventListener('beforeunload', function(e) {
    if (formChanged) {
        e.preventDefault();
        e.returnValue = '';
        return '';
    }
});
// Form submission with AJAX
document.getElementById('editProfileForm').addEventListener('submit', function(e) {
    e.preventDefault();
    showModal(
        'Save Changes',
        'Are you sure you want to save these changes?',
        function() {
            submitFormWithAjax();
        }
    );
});
function submitFormWithAjax() {
    const form = document.getElementById('editProfileForm');
    const formData = new FormData(form);
    const submitBtn = form.querySelector('button[type="submit"]');
    // Disable submit button and show loading
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<svg class="animate-spin h-5 w-5 text-white inline-block" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg> Saving...';
    fetch('{% url "user_profile:user_profile" %}', {
        method: 'POST',
        body: formData,
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRFToken': getCookie('csrftoken')
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('success', data.message || 'Profile updated successfully!');
            formChanged = false;
            setTimeout(() => {
                window.location.href = '{% url "user_profile:dashboard_user" %}';
            }, 1500);
        } else {
            showToast('error', data.message || 'Failed to update profile');
            submitBtn.disabled = false;
            submitBtn.innerHTML = 'Save Changes';
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('error', 'An error occurred while updating profile');
        submitBtn.disabled = false;
        submitBtn.innerHTML = 'Save Changes';
    });
}
// Toast notification function
function showToast(type, message) {
    const toastContainer = document.createElement('div');
    toastContainer.className = 'fixed bottom-4 right-4 z-50';
    const iconColor = type === 'success' ? 'text-green-500' : 'text-red-500';
    const borderColor = type === 'success' ? 'border-green-500' : 'border-red-500';
    const iconPath = type === 'success'
        ? 'M5 13l4 4L19 7'
        : 'M6 18L18 6M6 6l12 12';
    toastContainer.innerHTML = `
        <div class="bg-white rounded-lg shadow-lg border-l-4 ${borderColor} p-4 flex items-center gap-3 min-w-[300px] animate-slide-in">
            <div class="${iconColor}">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="${iconPath}"></path>
                </svg>
            </div>
            <p class="text-gray-800 font-medium">${message}</p>
        </div>
    `;
    document.body.appendChild(toastContainer);
    setTimeout(() => {
        toastContainer.classList.add('animate-slide-out');
        setTimeout(() => {
            document.body.removeChild(toastContainer);
        }, 300);
    }, 5000);
}
// Modal functions
function showModal(title, message, confirmCallback) {
    document.getElementById('modalTitle').textContent = title;
    document.getElementById('modalMessage').textContent = message;
    document.getElementById('confirmModal').classList.remove('hidden');
    const confirmBtn = document.getElementById('modalConfirmBtn');
    const cancelBtn = document.getElementById('modalCancelBtn');
    // Remove old event listeners
    const newConfirmBtn = confirmBtn.cloneNode(true);
    const newCancelBtn = cancelBtn.cloneNode(true);
    confirmBtn.parentNode.replaceChild(newConfirmBtn, confirmBtn);
    cancelBtn.parentNode.replaceChild(newCancelBtn, cancelBtn);
    // Add new event listeners
    document.getElementById('modalConfirmBtn').addEventListener('click', function() {
        hideModal();
        confirmCallback();
    });
    document.getElementById('modalCancelBtn').addEventListener('click', hideModal);
}
function hideModal() {
    document.getElementById('confirmModal').classList.add('hidden');
}
// Add CSS for animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slide-in {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    @keyframes slide-out {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
    .animate-slide-in {
        animation: slide-in 0.3s ease-out;
    }
    .animate-slide-out {
        animation: slide-out 0.3s ease-in;
    }
`;
document.head.appendChild(style);
</script>
{% endblock %}
````

## File: user_profile/admin.py
````python
class UserProfileAdmin(admin.ModelAdmin)
⋮----
list_display = ('user', 'created_at', 'updated_at')
search_fields = ('user__username', 'user__first_name', 'user__last_name')
class CoachProfileAdmin(admin.ModelAdmin)
⋮----
list_display = ('user', 'rating', 'verified', 'created_at')
⋮----
list_filter = ('verified', 'rating')
class CertificationAdmin(admin.ModelAdmin)
⋮----
list_display = ('coach', 'certificate_name', 'status', 'uploaded_at')
list_filter = ('status',)
search_fields = ('coach__user__username', 'certificate_name')
class AdminVerificationAdmin(admin.ModelAdmin)
⋮----
list_display = ('coach', 'status', 'created_at')
⋮----
search_fields = ('coach__user__username',)
````

## File: user_profile/apps.py
````python
class UserProfileConfig(AppConfig)
⋮----
default_auto_field = 'django.db.models.BigAutoField'
name = 'user_profile'
````

## File: user_profile/forms.py
````python
def get_sport_choices()
⋮----
categories = Category.objects.all().order_by('name')
⋮----
class TraineeRegistrationForm(UserCreationForm)
⋮----
first_name = forms.CharField(max_length=150, required=True)
last_name = forms.CharField(max_length=150, required=True)
class Meta
⋮----
model = User
fields = ['username', 'first_name', 'last_name', 'password1', 'password2']
def __init__(self, *args, **kwargs)
class CoachRegistrationForm(UserCreationForm)
⋮----
bio = forms.CharField(widget=forms.Textarea, required=True)
profile_image = forms.ImageField(required=False, help_text='Upload your profile picture')
⋮----
fields = ['username', 'first_name', 'last_name', 'password1', 'password2', 'bio', 'profile_image']
⋮----
def clean(self)
⋮----
cleaned_data = super().clean()
⋮----
def save(self, commit=True)
⋮----
user = super().save(commit=False)
````

## File: user_profile/models.py
````python
class UserProfile(models.Model)
⋮----
user = models.OneToOneField(User, on_delete=models.CASCADE)
profile_image = models.ImageField(upload_to='profile_images/', blank=True, null=True)
profile_image_url = models.URLField(max_length=500, blank=True, null=True)
created_at = models.DateTimeField(auto_now_add=True)
updated_at = models.DateTimeField(auto_now=True)
⋮----
@property
    def image_url(self)
def __str__(self)
class CoachProfile(models.Model)
⋮----
bio = models.TextField()
expertise = models.JSONField(default=list)
⋮----
rating = models.FloatField(default=0.0)
rating_count = models.PositiveIntegerField(default=0)
total_minutes_coached = models.PositiveIntegerField(default=0)
balance = models.PositiveIntegerField(
verified = models.BooleanField(default=False)
⋮----
@property
    def total_hours_coached(self)
⋮----
@property
    def total_hours_coached_formatted(self)
⋮----
hours = self.total_hours_coached
⋮----
@property
    def balance_formatted(self)
⋮----
class AdminVerification(models.Model)
⋮----
coach = models.OneToOneField(CoachProfile, on_delete=models.CASCADE)
certificate_url = models.CharField(max_length=255)
status = models.CharField(max_length=50, choices=[('pending', 'Pending'), ('approved', 'Approved'), ('rejected', 'Rejected')], default='pending')
notes = models.TextField(blank=True, null=True)
⋮----
class Certification(models.Model)
⋮----
STATUS_CHOICES = [
coach = models.ForeignKey(CoachProfile, on_delete=models.CASCADE)
certificate_name = models.CharField(max_length=255)
file_url = models.CharField(max_length=255)
status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
uploaded_at = models.DateTimeField(auto_now_add=True)
````

## File: user_profile/urls.py
````python
app_name = "user_profile"
urlpatterns = [
````

## File: user_profile/views.py
````python
MONTH_NAMES_SHORT_ID = [
def register_user(request)
⋮----
form = TraineeRegistrationForm(request.POST)
⋮----
user = form.save()
⋮----
errors = {}
⋮----
form = TraineeRegistrationForm()
context = {"form": form}
⋮----
def register_coach(request)
⋮----
form = CoachRegistrationForm(request.POST, request.FILES)
⋮----
expertise_list = request.POST.getlist('expertise[]')
⋮----
categories = Category.objects.all().order_by('name')
context = {"form": form, "categories": categories}
⋮----
coach_profile = CoachProfile.objects.create(
cert_names = request.POST.getlist('certification_name[]')
cert_urls = request.POST.getlist('certification_url[]')
⋮----
form = CoachRegistrationForm()
⋮----
def login_user(request)
⋮----
form = AuthenticationForm(data=request.POST)
from_modal = request.POST.get('from_modal', 'false') == 'true'
⋮----
user = form.get_user()
⋮----
next_url = request.GET.get('next', 'main:show_main')
⋮----
referer = request.META.get('HTTP_REFERER', '/')
separator = '&' if '?' in referer else '?'
⋮----
form = AuthenticationForm(request)
context = {'form': form}
⋮----
def logout_user(request)
⋮----
response = JsonResponse({
⋮----
response = HttpResponseRedirect(reverse('main:show_main'))
⋮----
@login_required
def dashboard_coach(request)
⋮----
coach_profile = CoachProfile.objects.get(user=request.user)
⋮----
certifications = Certification.objects.filter(coach=coach_profile)
context = {
⋮----
@login_required
def get_coach_profile(request)
⋮----
confirmed_bookings = Booking.objects.filter(
pending_bookings = Booking.objects.filter(
completed_bookings = Booking.objects.filter(
jakarta_tz = pytz.timezone('Asia/Jakarta')
def to_local(dt)
def format_datetime_local(dt)
⋮----
localized = to_local(dt)
⋮----
month_label = MONTH_NAMES_SHORT_ID[localized.month - 1]
⋮----
cancelled_bookings = Booking.objects.filter(
def format_booking(booking)
⋮----
start_str = format_datetime_local(booking.start_datetime)
end_str = format_datetime_local(booking.end_datetime)
⋮----
profile_data = {
⋮----
@login_required
def coach_profile(request)
⋮----
deleted_cert_ids = request.POST.getlist('deleted_certifications[]')
⋮----
new_cert_names = request.POST.getlist('new_cert_names[]')
new_cert_urls = request.POST.getlist('new_cert_urls[]')
⋮----
@login_required
def dashboard_user(request)
⋮----
@login_required
def get_user_profile(request)
⋮----
paid_bookings = Booking.objects.filter(
⋮----
chat_session = ChatSession.objects.filter(
chat_session_id = str(chat_session.id) if chat_session else None
⋮----
def format_completed_booking(booking)
⋮----
formatted = format_booking(booking)
review = Review.objects.filter(booking=booking).first()
⋮----
@login_required
def user_profile(request)
````

## File: .env.example
````
DB_NAME=<nama database>
DB_HOST=<host database>
DB_PORT=<port database>
DB_USER=<username database>
DB_PASSWORD=<password database>
SCHEMA=tugas_kelompok
PRODUCTION=True

# SSL settings for Neon (optional overrides)
# Neon requires SSL; defaults are set in settings.py, but you can override here if needed.
# DB_SSLMODE can be: disable|allow|prefer|require|verify-ca|verify-full
DB_SSLMODE=require
# If you need to specify certificates explicitly (usually not required with Neon):
# DB_SSLROOTCERT=/path/to/ca.pem
# DB_SSLCERT=/path/to/client.crt
# DB_SSLKEY=/path/to/client.key

# Alternatively, you can use a single DATABASE_URL (overrides discrete vars above if you wire it in):
# DATABASE_URL=postgres://<user>:<pass>@<host>:<port>/<db>?sslmode=require

# Midtrans Payment Gateway Configuration
# Get these from: https://dashboard.midtrans.com/settings/config_info
MIDTRANS_SERVER_KEY=your-server-key-here
MIDTRANS_CLIENT_KEY=your-client-key-here
MIDTRANS_IS_PRODUCTION=false  # Set to 'true' for production environment

# Cloudflare R2 Configuration (for media storage)
# Get these from: https://dash.cloudflare.com/?to=/:account/r2
R2_ACCESS_KEY_ID=your_r2_access_key_id
R2_SECRET_ACCESS_KEY=your_r2_secret_access_key
R2_BUCKET_NAME=your_bucket_name
R2_ENDPOINT_URL=https://your_account_id.r2.cloudflarestorage.com
R2_CUSTOM_DOMAIN=your_custom_domain.com  # or your cdn domain if using Cloudflare CDN

# To test R2 locally in development (set to True to use R2 instead of local filesystem):
USE_R2_LOCALLY=False
````

## File: .gitignore
````
# Django
*.log
*.pot
*.pyc
**pycache**
db.sqlite3
media
# Backup files
*.bak
# If you are using PyCharm
# User-specific stuff
.idea/**/workspace.xml
.idea/**/tasks.xml
.idea/**/usage.statistics.xml
.idea/**/dictionaries
.idea/**/shelf
# AWS User-specific
.idea/**/aws.xml
# Generated files
.idea/**/contentModel.xml
.DS_Store
# Sensitive or high-churn files
.idea/**/dataSources/
.idea/**/dataSources.ids
.idea/**/dataSources.local.xml
.idea/**/sqlDataSources.xml
.idea/**/dynamic.xml
.idea/**/uiDesigner.xml
.idea/**/dbnavigator.xml
# Gradle
.idea/**/gradle.xml
.idea/**/libraries
# File-based project format
*.iws
# IntelliJ
out/
# JIRA plugin
atlassian-ide-plugin.xml
# Python
*.py[cod]
*$py.class
# Distribution / packaging
.Python build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
*.manifest
*.spec
# Installer logs
pip-log.txt
pip-delete-this-directory.txt
# Unit test / coverage reports
htmlcov/
.tox/
.coverage
.coverage.*
.cache
.pytest_cache/
nosetests.xml
coverage.xml
*.cover
.hypothesis/
# Jupyter Notebook
.ipynb_checkpoints
# pyenv
.python-version
# celery
celerybeat-schedule.*
# SageMath parsed files
*.sage.py
# Environments
.env*
!.env.example*
.venv
env/
venv/
ENV/
env.bak/
venv.bak/
# mkdocs documentation
/site
# mypy
.mypy_cache/
# Sublime Text
*.tmlanguage.cache
*.tmPreferences.cache
*.stTheme.cache
*.sublime-workspace
*.sublime-project
# sftp configuration file
sftp-config.json
# Package control specific files Package
Control.last-run
Control.ca-list
Control.ca-bundle
Control.system-ca-bundle
GitHub.sublime-settings
# Visual Studio Code
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
.history
````

## File: manage.py
````python
def main()
````

## File: README.md
````markdown
# MamiCoach
> [!Note]
> **Anggota Kelompok PBP E02**:
> - Galih Nur Rizqy (2406343224)
> - Kevin Cornellius Widjaja (2406428781)
> - Natan Harum Panogu Silalahi (2406496170)
> - Vincent Valentino Oei (2406353225)
> - Vincentius Filbert Amadeo (2406351711)


### Table of Contents
- [MamiCoach](#mamicoach)
    - [Table of Contents](#table-of-contents)
  - [Deskripsi Aplikasi](#deskripsi-aplikasi)
  - [Penggunaan](#penggunaan)
  - [Daftar Modul](#daftar-modul)
  - [ERD](#erd)
  - [Sumber Data](#sumber-data)
  - [Peran Pengguna](#peran-pengguna)
    - [1. Pengguna (User)](#1-pengguna-user)
    - [2. Pelatih (Coach)](#2-pelatih-coach)
    - [3. Admin](#3-admin)
  - [Link Deployment \& Design](#link-deployment--design)


## Deskripsi Aplikasi
$${\color{green}\textbf{Mami}}\textbf{Coach}$$ adalah platform yang menghubungkan pelatih profesional dengan pengguna yang ingin belajar langsung dari ahlinya. Kami memfasilitasi jual beli kelas online dengan sistem rating, review, dan verifikasi pelatih untuk memastikan kredibilitas. 

Pengguna dapat menemukan pelatih berkualitas, membeli kelas, dan berinteraksi langsung, sementara pelatih dapat membangun reputasi, mengelola murid, dan mengembangkan bisnisnya. MamiCoach menciptakan ekosistem belajar yang transparan, terpercaya, dan berorientasi pada hasil nyata.


---

## Penggunaan

### 1. Setup Awal

#### Prerequisites:
- Python 3.8+ sudah terinstall
- pip (Python package manager)
- Git

#### Langkah-langkah Setup:

**Step 1: Clone Repository**
```bash
git clone https://github.com/pbp-kelompok-e02/mamicoach.git
cd mamicoach
```

**Step 2: Buat Virtual Environment**
```bash
# Windows
python -m venv env
env\Scripts\activate

# macOS / Linux
python3 -m venv env
source env/bin/activate
```


**Step 3: Install Dependencies**
```bash
pip install -r requirements.txt
```

**Step 4: Jalankan Migrasi Database**
```bash
python manage.py makemigrations
python manage.py migrate
```

**Step 5: Load Sample Data**
```bash
python manage.py populate_all
```

**Step 6: Buat Superuser (Admin)**
```bash
python manage.py createsuperuser
```

**Otomatis Setup (Quick Start):**

Jika OS anda adalah Windows, jalankan:
```ps
.\setup.bat
```

Jika OS anda UNIX based (macOS/Linux), jalankan:
```bash
chmod +x setup.sh
./setup.sh
```

Script ini akan otomatis melakukan semua langkah di atas.

### 2. Menjalankan Aplikasi
```bash
python manage.py runserver
```

Aplikasi akan tersedia di `http://localhost:8000/`

### 3. Login & Registrasi
- **Register User Baru:** Akses halaman registrasi untuk membuat akun sebagai User atau Coach
- **Login:** Gunakan username dan password untuk login ke aplikasi
- **Verifikasi Coach:** Jika register sebagai coach, tunggu verifikasi dari admin

### 4. Navigasi Aplikasi

#### Sebagai User (Pengguna):
1. **Dashboard Home** - Lihat daftar semua kelas yang tersedia
2. **Cari & Filter Kelas** - Gunakan filter untuk mencari kelas berdasarkan kategori, harga, atau rating
3. **Detail Kelas** - Klik kelas untuk melihat detail, deskripsi, jadwal, dan review dari coach
4. **Book Kelas** - Pilih tanggal dan waktu yang tersedia untuk membooking kelas
5. **Pembayaran** - Lakukan pembayaran melalui gateway yang tersedia
6. **Chat dengan Coach** - Setelah booking, bisa berkomunikasi dengan coach melalui fitur chat
7. **Beri Review** - Setelah kelas selesai, berikan rating dan review untuk coach

#### Sebagai Coach (Pelatih):
1. **Dashboard Coach** - Lihat overview murid, kelas, dan earnings
2. **Kelola Kelas** - Buat kelas baru, edit, atau hapus kelas
3. **Jadwal Ketersediaan** - Atur jadwal ketersediaan untuk sesi coaching
4. **Kelola Booking** - Lihat daftar booking dari murid, ubah status (Confirmed/Done/Canceled)
5. **Chat dengan Murid** - Berkomunikasi dengan murid sebelum dan sesudah kelas
6. **Lihat Review** - Monitoring rating dan review dari murid

#### Sebagai Admin:
1. **Admin Dashboard** - Lihat overview aplikasi
2. **Verifikasi Coach** - Review dan verifikasi akun coach baru
3. **Kelola Pengguna** - Lihat dan manage daftar semua pengguna
4. **Monitor Pembayaran** - Pantau transaksi dan status pembayaran

### 5. Fitur Utama

**Booking & Schedule:**
- Pilih kelas dan tanggal yang sesuai
- Lihat ketersediaan real-time dari coach
- Konfirmasi booking dan lanjut ke pembayaran

**Payment:**
- Proses pembayaran melalui Midtrans/gateway
- Lihat riwayat transaksi
- Invoice otomatis dikirim setelah pembayaran

**Chat & Komunikasi:**
- Real-time chat dengan coach/murid
- Chat hanya bisa diakses setelah booking
- History chat tersimpan

**Review & Rating:**
- Beri rating 1-5 bintang
- Tulis review/feedback
- Lihat review dari pengguna lain


### 6. Panduan Singkat Simulasi Pembayaran dengan Midtrans
Lakukan penjadwalan course pada aplikasi mamicoach, setelah anda mengkonfirmasi booking maka anda akan diarahkan ke laman pemilihan metode pembayaran, disini anda dapat memilih metode pembayaran yang anda inginkan dan melanjutkan pembayaran. 
Setelah sampai pada laman pembayaran milik midtrans, copy nomor virtual account atau identifier pembayaran lainnya yang tersedia pada laman tersebut. 
Selanjutnya anda dapat membuka website [simulator.sandbox.midtrans.com](https://simulator.sandbox.midtrans.com/) dan anda dapat memilih metode pembayaran yang sesuai seperti yang dipilih sebelumnya dan mensimulasikan payment. Setelah itu, anda dapat menekan `Refresh Status` pada laman payment milik midtrans dimana pembayaran anda akan terselesaikan dan anda akan diarahkan kembali ke mamicoach.

## Daftar Modul
| **Module Name** | **Description of Features** | **Delegated Unit** |
| -- | -- | -- |
| Authentication & User Management | Semua hal terkait akun, login, role, dan akses.<br><br>**Fitur:**<br>- Registrasi User & Coach<br>- Login / Logout (menggunakan Django Auth)<br>- Role-based access control (User, Coach, Admin)<br>- Verifikasi akun Coach oleh Admin<br>- Profile page (edit data pribadi, hanya terlihat oleh user login)<br>- Template: `register.html`, `login.html`, `profile.html`<br>- AJAX untuk validasi username/email<br>- Model:<br>  - `CoachProfile` <br>  - `UserProfile` <br>  - `AdminVerification` | Natan Harum Panogu Silalahi [2406496170] |
| Class & Coach Management | Manajemen kelas dan profil coach.<br><br>**Fitur:**<br>- Coach membuat, mengedit, dan menghapus kelas.<br>- Tampilkan daftar semua kelas + filter (olahraga, harga, level).<br>- Detail halaman kelas (coach, deskripsi, harga, rating).<br>- Upload sertifikasi (untuk verifikasi coach).<br>- Admin memverifikasi sertifikat → beri badge *Verified Coach*.<br>- Template: `class_list.html`, `class_detail.html`, `coach_list.html`<br>- AJAX filter kelas per kategori olahraga.<br>- Model:<br>  - `Course`<br>  - `Category`<br> | Kevin Cornellius Widjaja [2406428781] |
| Booking & Schedule | Proses booking kelas, pemilihan jadwal, dan status.<br><br>**Fitur:**<br>- Form booking (pilih kelas, tanggal, jam).<br>- Filter kelas berdasarkan hari & coach.<br>- Dashboard user: daftar booking (Pending, Confirmed, Done).<br>- Dashboard coach: daftar sesi masuk.<br>- AJAX update status (coach → Confirmed/Done/Canceled).<br>- Model:<br>  - `Booking` (`user`, `coach`, `class`, `date`, `status`)<br>  - `ScheduleSlot` (slot waktu yang ditawarkan coach) | Galih Nur Rizqy [2406343224] |
| Payment System | Simulasi atau integrasi gateway (Xendit sandbox).<br><br>**Fitur:**<br>- Generate invoice (via Xendit API atau dummy page).<br>- Status pembayaran (`Pending`, `Paid`).<br>- Webhook handler (jika pakai sandbox).<br>- Tampilan riwayat transaksi user.<br>- Template: `payment_page.html`, `payment_success.html`<br>- AJAX update status payment otomatis setelah webhook.<br>- Model:<br>  - `Payment` (booking_id, amount, status, method, timestamp)<br>- Admin page untuk konfirmasi pembayaran ke coach dan refund ke user | Vincentius Filbert Amadeo [2406351711] |
| Chat & Review | Interaksi & feedback user terhadap coach.<br><br>**Fitur:**<br>- Real-time chat sederhana (AJAX polling).<br>- Chat hanya terbuka jika user sudah booking kelas.<br>- Setelah kelas selesai → form review (rating + komentar).<br>- Tampilkan review di halaman kelas dan profil coach.<br>- Template: `chat.html`, `review_form.html`, `reviews_section.html`<br>- Model:<br>  - `ChatMessage`<br> - `ChatSession`<br>  - `Review` (rating, komentar, user, class, coach) | Vincent Valentino Oei [2406353225] |



## ERD
[ERD Link](https://dbdiagram.io/d/68e6390fd2b621e422d55017)
> [!Note]
> Subject to Change

## Sumber Data
[Superprof.id](https://www.superprof.co.id/)

Data yang telah discrape:
- [Coaches](./dataset/main_coach.csv)
- [Courses](./dataset/main_course.csv)

> [!Note]
> Semua sumber data dikurasi, diperoleh, dan dimodifikasi secara manual untuk menyesuaikan kebutuhan data dalam proyek ini.


## Peran Pengguna

### 1. Pengguna (User)
Peran ini ditujukan untuk individu yang ingin belajar dan mengembangkan keterampilan baru. Mereka adalah konsumen utama di platform Mamicoach.

**Deskripsi & Hak Akses:**
- **Mencari & Menemukan:** Dapat menjelajahi semua kategori, mencari pelatih, dan memfilter kelas berdasarkan subjek, rating, atau harga.
- **Membeli Kelas:** Dapat melakukan transaksi pembelian kelas yang diminati.
- **Mengikuti Kelas:** Memiliki akses ke materi kelas yang sudah dibeli dan dapat berinteraksi dengan pelatih.
- **Memberi Rating & Review:** Setelah menyelesaikan kelas, mereka dapat memberikan penilaian dan ulasan yang akan terlihat oleh publik untuk membantu pengguna lain.

---

### 2. Pelatih (Coach)
Peran ini untuk para profesional atau ahli di bidangnya yang ingin membagikan ilmunya dan membangun bisnis pelatihan secara online.

**Deskripsi & Hak Akses:**
- **Profil Terverifikasi:** Memiliki halaman profil publik yang menampilkan keahlian, pengalaman, dan portofolio setelah melewati proses verifikasi oleh Mamicoach.
- **Membuat & Mengelola Kelas:** Dapat membuat, mengedit, dan mempublikasikan kelas online, termasuk menentukan kurikulum, harga, dan jadwal.
- **Mengelola Murid:** Dapat melihat daftar murid yang terdaftar di kelasnya, berinteraksi, dan memantau kemajuan mereka.
- **Membangun Reputasi:** Menerima rating dan review dari murid, yang akan membangun kredibilitas dan reputasi mereka di platform.


### 3. Admin
Peran ini untuk pengelola platform yang bertanggung jawab menjaga kualitas, keamanan, dan operasional MamiCoach. Berdasarkan pembagian modul, Admin memiliki akses dan tugas spesifik untuk memastikan platform berjalan lancar.

**Deskripsi & Hak Akses:**
- **Verifikasi Pelatih:** Meninjau pendaftaran pelatih baru, memverifikasi sertifikat yang diunggah, dan memberikan status "Verified Coach" untuk menjaga kredibilitas platform.
- **Manajemen Pembayaran:** Mengelola alur keuangan, termasuk mengonfirmasi pembayaran dari pengguna dan meneruskan pembayaran (*payout*) kepada pelatih.
- **Manajemen Pengembalian Dana (Refund):** Memproses dan menyetujui permintaan pengembalian dana dari pengguna sesuai dengan kebijakan yang berlaku.


## Link Deployment & Design
- [Link Deployment](https://kevin-cornellius-mamicoach.pbp.cs.ui.ac.id/)
- [Link Figma](https://www.figma.com/design/Ysa8K8heNxQcG8eyjdRAXD/TK-PBP-E02?node-id=0-1&t=q5cEKERHtkHz8QlB-1)
````

## File: requirements.txt
````
django
gunicorn
whitenoise
psycopg2-binary
requests
urllib3
python-dotenv
dj-database-url
Pillow
midtransclient
pytz
coverage
django-storages
boto3
````

## File: sonar-project.properties
````
sonar.projectKey=pbp-kelompok-e02_mamicoach_44c9c530-d962-4551-9b80-32faafea4cc3
````
